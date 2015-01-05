
//
//  XSDschema.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "XSDschema.h"
#import "XSSimpleType.h"
#import "XSDcomplexType.h"
#import "XSDelement.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "DDFrameworkWriter.h"

@interface XSDcomplexType (privateAccessors)
@property (strong, nonatomic) NSArray* globalElements;
@end

@interface XSDschema ()

@property (strong, nonatomic) NSURL* schemaUrl;
@property (strong, nonatomic) NSString* targetNamespace;
@property (strong, nonatomic) NSArray* allNamespaces;
@property (strong, nonatomic) NSArray* complexTypes;
@property (strong, nonatomic) NSArray* includedSchemas;
@property (strong, nonatomic) NSArray* simpleTypes;

@property (weak, nonatomic) XSDschema* parentSchema;

@property (strong, nonatomic) NSString* complexTypeArrayType;
@property (strong, nonatomic) NSString* readComplexTypeElementTemplate;
@property (strong, nonatomic) NSString* readerClassTemplateString;
@property (strong, nonatomic) NSString* readerHeaderTemplateString;
@property (strong, nonatomic) NSString* classTemplateString;
@property (strong, nonatomic) NSString* headerTemplateString;
@property (strong, nonatomic) NSArray* additionalFiles;
@property (strong, nonatomic) NSString* classPrefix;

@end

@implementation XSDschema {
    NSMutableDictionary* _knownSimpleTypeDict;
    NSMutableDictionary* _knownComplexTypeDict;
}

// Called when initializing the object from a node
- (id) initWithNode: (NSXMLElement*) node prefix: (NSString*) prefix error: (NSError**) error  {
	self = [super initWithNode:node schema:nil];
    if(self) {
        //get namespaces and set derived class prefix
        self.targetNamespace = [[node attributeForName: @"targetNamespace"] stringValue];
        self.allNamespaces = [node namespaces];
        [self setPrefixFromNamespaceWithOverride:prefix];
        
        
        //add basic simple types
        _knownSimpleTypeDict = [NSMutableDictionary dictionary];
        for(XSSimpleType *aSimpleType in [XSSimpleType knownSimpleTypes]) {
            [_knownSimpleTypeDict setValue: aSimpleType forKey: aSimpleType.name];
        }
        
        //add custom simple types
        self.simpleTypes = [NSMutableArray array];
        NSArray* stNodes = [node nodesForXPath: @"/schema/simpleType" error: error];
        for (NSXMLElement* aChild in stNodes) {
            XSSimpleType* aCT = [[XSSimpleType alloc] initWithNode: aChild schema: self];
            [((NSMutableDictionary*)_knownSimpleTypeDict) setObject:aCT forKey:aCT.name];
            [((NSMutableArray*)self.simpleTypes) addObject: aCT];
        }

        //add complex types, collect global elements
        _knownComplexTypeDict = [NSMutableDictionary dictionary];
        self.complexTypes = [NSMutableArray array];
        NSArray* ctNodes = [node nodesForXPath: @"/schema/complexType" error: error];
        for (NSXMLElement* aChild in ctNodes) {
            XSDcomplexType* aCT = [[XSDcomplexType alloc] initWithNode: aChild schema: self];
            [((NSMutableDictionary*)_knownComplexTypeDict) setObject:aCT forKey:aCT.name];
            [((NSMutableArray*)self.complexTypes) addObject: aCT];
        }

        //Find globals
        NSMutableArray* globalElements = [NSMutableArray array];
        NSArray* geNodes = [node nodesForXPath: @"/schema/element" error: error];
        for (NSXMLElement* aChild in geNodes) {
            XSDelement* anElement = [[XSDelement alloc] initWithNode: aChild schema: self];
            [globalElements addObject: anElement];
        }

        //connect types and globals
        for (XSDelement* anElement in globalElements) {
            id<XSType> aType = [anElement schemaType];
            if( [aType isMemberOfClass: [XSDcomplexType class]]) {
                ((XSDcomplexType*)aType).globalElements = [((XSDcomplexType*)aType).globalElements arrayByAddingObject: anElement];
            }
        }
	}
	return self;
}

- (id) initWithUrl: (NSURL*) schemaUrl prefix: (NSString*) prefix error: (NSError**) error {
    NSData* data = [NSData dataWithContentsOfURL: schemaUrl];
    if(!data) {
        *error = [NSError errorWithDomain:@"XSDschema" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:@"Cant open xsd file at %@", schemaUrl]}];
        return nil;
    }
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData: data options: 0 error: error];
    if(!doc) {
        return nil;
    }
    
    self = [self initWithNode: [doc rootElement] prefix: prefix error: error];
    if(self) {
        self.schemaUrl = schemaUrl;
        
        //handle includes
        NSArray* iNodes = [[doc rootElement] nodesForXPath: @"/schema/include" error: error];
        self.includedSchemas = [NSMutableArray array];
        for (NSXMLElement* aChild in iNodes) {

            id schemaLocation = [aChild attributeForName:@"schemaLocation"].stringValue;
            NSURL *url = [NSURL URLWithString:schemaLocation relativeToURL:schemaUrl];
            XSDschema *xsd = [[self.class alloc] initWithUrl:url prefix:prefix error:error];
            if(!xsd) {
                return nil;
            }
            
            xsd.parentSchema = self;
            [((NSMutableArray*)self.includedSchemas) addObject: xsd];
            
            //also add their types to ours, because we fricking know them now :D
            for (XSDcomplexType *ct in xsd.complexTypes) {
                [(NSMutableDictionary*)_knownComplexTypeDict setObject:ct forKey:ct.name];
                [(NSMutableArray*)self.complexTypes addObject:ct];
            }
            //also add their types to ours, because we fricking know them now :D
            for (XSSimpleType *ct in xsd.simpleTypes) {
                [(NSMutableDictionary*)_knownSimpleTypeDict setObject:ct forKey:ct.name];
                [(NSMutableArray*)self.simpleTypes addObject:ct];
            }
        }
    }
    
    return self;
}

#pragma mark -

- (void)setPrefixFromNamespaceWithOverride:(NSString*)prefix {
    //set class prefix
    if(prefix != nil) {
        self.classPrefix = prefix;
    } else {
        for (NSXMLNode *node in self.allNamespaces) {
            NSString* nsURI = node.stringValue;
            
            if([nsURI isEqualTo: self.targetNamespace]) {
                self.classPrefix = node.name;
            }
        }
    }
    
    //fix prefix so it is empty or uppercase
    if(!self.classPrefix) {
        self.classPrefix = @"";
    }
    else {
        self.classPrefix = [self.classPrefix uppercaseString];
    }
}

- (void) addType: (XSDcomplexType*) cType {
    if([cType isKindOfClass:[XSDcomplexType class]]) {
        [((NSMutableDictionary*) _knownComplexTypeDict) setObject:cType forKey:cType.name];
        [((NSMutableArray*)self.complexTypes) addObject: cType];
    }
    else if([cType isKindOfClass:[XSSimpleType class]]) {
        [((NSMutableDictionary*) _knownSimpleTypeDict) setObject:cType forKey:cType.name];
        [((NSMutableArray*)self.simpleTypes) addObject: cType];
    }
}

- (BOOL) loadTemplate: (NSURL*) templateUrl error: (NSError**) error {
    NSParameterAssert(templateUrl);
    NSParameterAssert(error);
    
    NSXMLDocument* xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL: templateUrl
                                                                 options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                                   error: error];
    if(*error != nil) {
        return NO;
    }
    
    NSArray* additionalFileNodes = [xmlDoc nodesForXPath:@"/template[1]/additional_file" error: error];
    if(*error != nil) {
        return NO;
    }
    NSMutableArray *mAdditionalFiles = [NSMutableArray arrayWithCapacity:additionalFileNodes.count];
    for(NSXMLElement* fileNode in additionalFileNodes) {
        NSString *path = [[[NSBundle bundleForClass:[XSDschema class]] resourcePath] stringByAppendingPathComponent:[fileNode attributeForName:@"path"].stringValue];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            path = [fileNode attributeForName:@"path"].stringValue;
            if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                path = nil;
            }
        }
        
        if(path) {
            [mAdditionalFiles addObject:path];
        }
    }
    if(mAdditionalFiles.count) {
        self.additionalFiles = [NSArray arrayWithArray:mAdditionalFiles];
    }
    
    NSArray* simpleTypeNodes = [xmlDoc nodesForXPath:@"/template[1]/simpletype" error: error];
    if(*error != nil) {
        return NO;
    }
    
    for(NSXMLElement* aSimpleTypeNode in simpleTypeNodes) {
        //check if we can find that type or we have to add it
        XSSimpleType* aSimpleType = [[XSSimpleType alloc] initWithNode:aSimpleTypeNode schema:self];//should happen earlier
        XSSimpleType *existingSimpleType = _knownSimpleTypeDict[aSimpleType.name];
        if(existingSimpleType) {
            [existingSimpleType supplyTemplates:aSimpleTypeNode error:error];
        
        }
        else {
            [aSimpleType  supplyTemplates:aSimpleTypeNode error:error];
            [_knownSimpleTypeDict setValue: aSimpleType forKey: aSimpleType.name];
            //not a custom one though
//            [((NSMutableArray*)self.simpleTypes) addObject: aSimpleType];
        }
    }
    
    NSArray* nodes = [xmlDoc nodesForXPath:@"/template[1]/implementation[1]/header" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.headerTemplateString = [[nodes objectAtIndex: 0] stringValue];
    }
    
    nodes = [xmlDoc nodesForXPath:@"/template[1]/implementation[1]/class" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.classTemplateString = [[nodes objectAtIndex: 0] stringValue];
    }
    
    nodes = [xmlDoc nodesForXPath:@"/template[1]/complextype[1]/read[1]/element[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.readComplexTypeElementTemplate = [[nodes objectAtIndex: 0] stringValue];
    }
    
    nodes = [xmlDoc nodesForXPath:@"/template[1]/complextype[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.complexTypeArrayType = [[nodes objectAtIndex: 0] attributeForName:@"arrayType"].stringValue;
    }
    //
    
    nodes = [xmlDoc nodesForXPath:@"/template[1]/reader[1]/header" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.readerHeaderTemplateString = [[nodes objectAtIndex: 0] stringValue];
    }
    
    nodes = [xmlDoc nodesForXPath:@"/template[1]/reader[1]/class" error: error];
    if(*error != nil) {
        return NO;
    }
    
    if(nodes != nil && nodes.count > 0) {
        self.readerClassTemplateString = [[nodes objectAtIndex: 0] stringValue];
    }
 
    for (XSDschema *s in self.includedSchemas) {
        BOOL br = [s loadTemplate:templateUrl error:error];
        if(!br) {
            return NO;
        }
    }
    return YES;
}

- (id<XSType>) typeForName: (NSString*) qName {
    if(self.parentSchema) {
        //defer
        return [self.parentSchema typeForName:qName];
    }
    
    NSParameterAssert(qName.length); //EVERYTHING has a type name
    
    NSString* typeName = qName;
    NSArray* splitPrefix = [qName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @":"]];
    
    if(splitPrefix.count > 1) {
        typeName = (NSString*) [splitPrefix objectAtIndex: 1];
    }
    
    //search ct
    id<XSType> retType = [_knownComplexTypeDict objectForKey: typeName];
    
    //search st
    if(!retType) {
        retType = [_knownSimpleTypeDict objectForKey: typeName];
    }
    
    assert(retType); //EVERYTHING has to have a type
    return retType;
}

+ (NSString*) variableNameFromName:(NSString*)vName multiple:(BOOL)multiple {
    NSParameterAssert(vName.length);
    
    NSCharacterSet* illegalChars = [NSCharacterSet characterSetWithCharactersInString: @"-"];
    NSRange range = [vName rangeOfCharacterFromSet: illegalChars];
    while(range.length > 0) {
        vName = [vName stringByReplacingCharactersInRange: range withString: @""];
        // range is now at next char
        vName = [vName stringByReplacingCharactersInRange: range withString:[[vName substringWithRange: range] uppercaseString]];
        
        range = [vName rangeOfCharacterFromSet: illegalChars];
    }
    
    //grammar fix
    if(multiple) {
        if(![vName hasSuffix:@"s"])
        {
            if([vName hasSuffix:@"y"]) {
                vName = [vName substringToIndex:vName.length-1];
                vName = [vName stringByAppendingString:@"ies"];
            }
            else {
                vName = [vName stringByAppendingString:@"s"];
            }
        }
    }
    //id fix
    if([vName caseInsensitiveCompare:@"id"]==NSOrderedSame) {
        vName = @"identifier";
    }
    //copy fix
    if([vName caseInsensitiveCompare:@"copy"]==NSOrderedSame) {
        vName = @"textCopy";
    }
    //class fix
    if([vName caseInsensitiveCompare:@"class"]==NSOrderedSame) {
        vName = @"typeClass";
    }
    
    assert(vName.length); //EVERYTHING has a name
    return vName;
}

#pragma mark - generator

- (BOOL) generateInto: (NSURL*) destinationFolder
             products: (XSDschemaGeneratorOptions)options
                error: (NSError**) error {
    NSParameterAssert(destinationFolder);
    NSParameterAssert(error);
    
    //write code
    if (options & XSDschemaGeneratorOptionSourceCode) {
        NSURL *srcFolderUrl = [destinationFolder URLByAppendingPathComponent:@"Sources" isDirectory:YES];
        
        if(![[NSFileManager defaultManager] createDirectoryAtURL:srcFolderUrl withIntermediateDirectories:NO attributes:nil error:error]) {
            BOOL isDir;
            if(![[NSFileManager defaultManager] fileExistsAtPath:srcFolderUrl.path isDirectory:&isDir] || !isDir) {
                return NO;
            }
        }
        if(![self writeCodeInto:srcFolderUrl error:error]) {
            return NO;
        }
    }

    //write Framework
    if (options & XSDschemaGeneratorOptionDynamicFramework) {
        NSURL *productsFolderUrl = [destinationFolder URLByAppendingPathComponent:@"Products" isDirectory:YES];
        NSURL *osxFolderUrl = [productsFolderUrl URLByAppendingPathComponent:@"OSX" isDirectory:YES];
        
        if(![[NSFileManager defaultManager] createDirectoryAtURL:osxFolderUrl withIntermediateDirectories:YES attributes:nil error:error]) {
            BOOL isDir;
            if(![[NSFileManager defaultManager] fileExistsAtPath:osxFolderUrl.path isDirectory:&isDir] || !isDir) {
                return NO;
            }
        }
        
        if(![self writeFrameworkTo:osxFolderUrl error:error]) {
            return NO;
        }

        NSURL *iosFolderUrl = [productsFolderUrl URLByAppendingPathComponent:@"IOS" isDirectory:YES];
        
        if(![[NSFileManager defaultManager] createDirectoryAtURL:iosFolderUrl withIntermediateDirectories:YES attributes:nil error:error]) {
            BOOL isDir;
            if(![[NSFileManager defaultManager] fileExistsAtPath:iosFolderUrl.path isDirectory:&isDir] || !isDir) {
                return NO;
            }
        }
        
        if(![self writeModuleTo:iosFolderUrl error:error]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) writeCodeInto: (NSURL*) destinationFolder
                 error: (NSError**) error {
    *error = nil;
    
    //if there is no template, we quit
    if(!self.complexTypeArrayType) {
        return NO;
    }
    
    // Set up template engine with your chosen matcher.
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    //write classes
    for(XSDcomplexType* type in self.complexTypes) {
        if (self.headerTemplateString != nil) {
            NSString *result = [engine processTemplate: self.headerTemplateString
                                         withVariables: type.substitutionDict];
            
            NSString* headerFileName = [NSString stringWithFormat: @"%@.h", type.targetClassFileName];
            NSURL* headerFilePath = [destinationFolder URLByAppendingPathComponent: headerFileName];
            [result writeToURL: headerFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
            if(*error != nil) {
                return NO;
            }
        }
        
        if (self.classTemplateString != nil) {
            NSString *result = [engine processTemplate: self.classTemplateString
                                         withVariables: type.substitutionDict];
            
            NSString* classFileName = [NSString stringWithFormat: @"%@.m", type.targetClassFileName];
            NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
            [result writeToURL: classFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
            if(*error != nil) {
                return NO;
            }
        }
        
        // reader for type
        if(type.globalElements.count) {
            if (self.readerHeaderTemplateString != nil) {
                NSString *result = [engine processTemplate: self.readerHeaderTemplateString
                                             withVariables: type.substitutionDict];
                
                NSString* headerFileName = [NSString stringWithFormat: @"%@+File.h", type.targetClassFileName];
                NSURL* headerFilePath = [destinationFolder URLByAppendingPathComponent: headerFileName];
                [result writeToURL: headerFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
                if(*error != nil) {
                    return NO;
                }
            }
            
            if (self.readerClassTemplateString != nil) {
                NSString *result = [engine processTemplate: self.readerClassTemplateString
                                             withVariables: type.substitutionDict];
                
                NSString* classFileName = [NSString stringWithFormat: @"%@+File.m", type.targetClassFileName];
                NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
                [result writeToURL: classFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
                if(*error != nil) {
                    return NO;
                }
            }
        }
    }
    
    //copy additional files
    for (NSString *filePath in self.additionalFiles) {
        NSString *destPath = [destinationFolder.path stringByAppendingPathComponent:filePath.lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:nil];
    }
    
    //add header
    NSString *fileName = [NSString stringWithFormat:@"%@.h", self.schemaUrl.lastPathComponent.stringByDeletingPathExtension];
    NSURL *filePath = [destinationFolder URLByAppendingPathComponent:fileName];
    
    //add includes for all other files
    NSString *includes = [self contentOfUmbrellaHeaderForFolder:destinationFolder];
    BOOL br = [includes writeToURL:filePath atomically:YES encoding:NSUTF8StringEncoding error:error];
    if(!br) {
        return NO;
    }
    
    return YES;
}

- (NSString*)contentOfUmbrellaHeaderForFolder:(NSURL*)destinationFolder {
    NSParameterAssert(destinationFolder);
    
    NSDirectoryEnumerator *dirEnumerator = [[NSFileManager defaultManager] enumeratorAtURL:destinationFolder
                                                                includingPropertiesForKeys:@[ NSURLNameKey, NSURLIsDirectoryKey ]
                                                                                   options:NSDirectoryEnumerationSkipsPackageDescendants| NSDirectoryEnumerationSkipsHiddenFiles
                                                                              errorHandler:nil];

    NSMutableString *includes = [NSMutableString string];
    for (NSURL *theURL in dirEnumerator) {
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        if (![isDirectory boolValue]) {
            if([theURL.pathExtension isEqualTo:@"h"]) {
                if(includes.length) {
                    [includes appendString:@"\n"];
                }
                [includes appendFormat:@"#import \"%@\"", theURL.lastPathComponent];
            }
        }
    }
    
    return includes;
}

- (BOOL)writeFrameworkTo:(NSURL*)destinationFolder error:(NSError**)error {
    NSURL *tmpFolderUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:tmpFolderUrl withIntermediateDirectories:NO attributes:nil error:error]) {
        return NO;
    }
    if(![self writeCodeInto:tmpFolderUrl error:error]) {
        return NO;
    }
    
    id name = self.schemaUrl.lastPathComponent.stringByDeletingPathExtension;
    id bid = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingFormat:@".%@-parser", name];
    id files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:tmpFolderUrl includingPropertiesForKeys:nil options:0 error:nil];
    id flags = @[@"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation", @"-lxml2", @"-I/usr/include/libxml2"];
    id resources = @[self.schemaUrl.path];
    
    if(![[DDFrameworkWriter sharedWriter] writeFrameworkWithIdentifier:bid
                                                               andName:name
                                                                atPath:tmpFolderUrl.path
                                                            inputFiles:[files valueForKey:@"path"]
                                                         resourceFiles:resources
                                                       additionalFlags:flags
                                                                 error:error]) {
        return NO;
    }

    NSURL *frameworkSrc = [[tmpFolderUrl URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"framework"];
    
    NSURL *frameworkDest = [[destinationFolder URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"framework"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:frameworkDest.path]) {
        if(![[NSFileManager defaultManager] removeItemAtURL:frameworkDest error:error]) {
            return NO;
        }

    }
    if(![[NSFileManager defaultManager] copyItemAtURL:frameworkSrc toURL:frameworkDest error:error]) {
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtURL:tmpFolderUrl error:error];
}

- (BOOL)writeModuleTo:(NSURL*)destinationFolder error:(NSError**)error {
    NSURL *tmpFolderUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    
    if(![[NSFileManager defaultManager] createDirectoryAtURL:tmpFolderUrl withIntermediateDirectories:NO attributes:nil error:error]) {
        return NO;
    }
    if(![self writeCodeInto:tmpFolderUrl error:error]) {
        return NO;
    }
    
    id name = self.schemaUrl.lastPathComponent.stringByDeletingPathExtension;
    id bid = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingFormat:@".%@-parser", name];
    id files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:tmpFolderUrl includingPropertiesForKeys:nil options:0 error:nil];
    id flags = @[@"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"armv7", @"-framework", @"foundation", @"-lxml2", @"-I/usr/include/libxml2", @"-isysroot", @"/Applications/Xcode-Beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.2.sdk"];
    id resources = @[self.schemaUrl.path];
    
    if(![[DDFrameworkWriter sharedWriter] writeModuleWithIdentifier:bid
                                                            andName:name
                                                             atPath:tmpFolderUrl.path
                                                         inputFiles:[files valueForKey:@"path"]
                                                         resourceFiles:resources
                                                       additionalFlags:flags
                                                                 error:error]) {
        return NO;
    }
    
    NSURL *frameworkSrc = [[tmpFolderUrl URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"framework"];
    
    NSURL *frameworkDest = [[destinationFolder URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"framework"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:frameworkDest.path]) {
        if(![[NSFileManager defaultManager] removeItemAtURL:frameworkDest error:error]) {
            return NO;
        }
        
    }
    if(![[NSFileManager defaultManager] copyItemAtURL:frameworkSrc toURL:frameworkDest error:error]) {
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtURL:tmpFolderUrl error:error];
}

@end
