
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
#import "XMLUtils.h"

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
@property (strong, nonatomic) NSString *targetNamespacePrefix;
@end

@implementation XSDschema {
    NSMutableDictionary* _knownSimpleTypeDict;
    NSMutableDictionary* _knownComplexTypeDict;
}

// Called when initializing the object from a node
- (id) initWithNode: (NSXMLElement*) node targetNamespacePrefix: (NSString*) prefix error: (NSError**) error  {
	self = [super initWithNode:node schema:nil];
    if(self) {
        /* Get namespaces and set derived class prefix */
        self.targetNamespace = [[node attributeForName: @"targetNamespace"] stringValue];
        self.allNamespaces = [node namespaces];
        [self setTargetNamespacePrefixOverride:prefix];
        
        
        /* Add basic simple types known in the built-in types */
        _knownSimpleTypeDict = [NSMutableDictionary dictionary];
        for(XSSimpleType *aSimpleType in [XSSimpleType knownSimpleTypes]) {
            [_knownSimpleTypeDict setValue: aSimpleType forKey: aSimpleType.name];
        }
        
        /* Add custom simple types */
        self.simpleTypes = [NSMutableArray array];
        NSArray* stNodes = [node nodesForXPath: @"/schema/simpleType" error: error];
        NSLog(@"Simple Types Length: %ld", [stNodes count]);
        for (NSXMLElement* aChild in stNodes) {
            XSSimpleType* aCT = [[XSSimpleType alloc] initWithNode: aChild schema: self];
            [((NSMutableDictionary*)_knownSimpleTypeDict) setObject:aCT forKey:aCT.name];
            [((NSMutableArray*)self.simpleTypes) addObject: aCT];
        }

        /* Add complex types, collect global elements */
        _knownComplexTypeDict = [NSMutableDictionary dictionary];
        self.complexTypes = [NSMutableArray array];
        NSArray* ctNodes = [node nodesForXPath: @"/schema/complexType" error: error];
        NSLog(@"Complex Types Length: %ld", [ctNodes count]);
        for (NSXMLElement* aChild in ctNodes) {
            XSDcomplexType* aCT = [[XSDcomplexType alloc] initWithNode: aChild schema: self];
            [((NSMutableDictionary*)_knownComplexTypeDict) setObject:aCT forKey:aCT.name];
            [((NSMutableArray*)self.complexTypes) addObject: aCT];
        }

        /* Add the globals elements */
        NSMutableArray* globalElements = [NSMutableArray array];
        NSArray* geNodes = [node nodesForXPath: @"/schema/element" error: error];
        NSLog(@"Elements Length: %ld", [geNodes count]);
        for (NSXMLElement* aChild in geNodes) {
            XSDelement* anElement = [[XSDelement alloc] initWithNode: aChild schema: self];
            [globalElements addObject: anElement];
        }

        /* For each global element found, connect the type */
        for (XSDelement* anElement in globalElements) {
            id<XSType> aType = [anElement schemaType];
            NSLog(@"Type Name: %@", anElement.type);
            /* For the type check if it is in our found complex types */
            if( [aType isMemberOfClass: [XSDcomplexType class]]) {
                ((XSDcomplexType*)aType).globalElements = [((XSDcomplexType*)aType).globalElements arrayByAddingObject: anElement];
            }
        }
	}
    
    /* Return our created object with all the elements and generated types */
	return self;
}

- (id) initWithUrl: (NSURL*) schemaUrl targetNamespacePrefix: (NSString*) prefix error: (NSError**) error {
    NSData* data = [NSData dataWithContentsOfURL: schemaUrl];
    NSLog(@"Data: %@", [NSString stringWithUTF8String:[data bytes]]);
    /* If we do not have data present an instance error that we cannot open the xsd file at the given location */
    if(!data) {
        *error = [NSError errorWithDomain:@"XSDschema" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:@"Cant open xsd file at %@", schemaUrl]}];
        return nil;
    }
    /* Create a document tree structure */
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData: data options: 0 error: error];
    if(!doc) {
        return nil;
    }
    
    /* From the root element, grab the complex, simple, and elements */
    self = [self initWithNode: [doc rootElement] targetNamespacePrefix: prefix error: error];

    if(self) {
        /* The location of where our schema is located */
        self.schemaUrl = schemaUrl;
        
        //handle includes & imports
        NSArray* iNodes = [[doc rootElement] nodesForXPath: @"/schema/include" error: error];
        NSArray* iNodes2 = [[doc rootElement] nodesForXPath: @"/schema/import" error: error];
        if(iNodes2.count) {
            NSMutableArray *newNodes = [iNodes2 mutableCopy];
            if(iNodes.count) {
                [newNodes addObjectsFromArray:iNodes];
            }
            iNodes = newNodes;
        }
        
        /* For the imported schemas, grab their complex and simple types of their elements */
        self.includedSchemas = [NSMutableArray array];
        for (NSXMLElement* aChild in iNodes) {

            id schemaLocation = [aChild attributeForName:@"schemaLocation"].stringValue;
            NSURL *url = [NSURL URLWithString:schemaLocation relativeToURL:schemaUrl];
            XSDschema *xsd = [[self.class alloc] initWithUrl:url targetNamespacePrefix:prefix error:error];
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

- (void)setTargetNamespacePrefixOverride:(NSString*)prefix {
    //set class prefix
    if(prefix != nil) {
        self.targetNamespacePrefix = prefix;
    } else {
        for (NSXMLNode *node in self.allNamespaces) {
            NSString* nsURI = node.stringValue;
            
            if([nsURI isEqualTo: self.targetNamespace]) {
                self.targetNamespacePrefix = node.name;
            }
        }
    }
    
    //fix prefix so it is empty or uppercase
    if(!self.targetNamespacePrefix) {
        self.targetNamespacePrefix = @"";
    }
    else {
        self.targetNamespacePrefix = [self.targetNamespacePrefix uppercaseString];
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
/**
 *
 *
 */

- (BOOL) loadTemplate: (NSURL*) templateUrl error: (NSError**) error {
    NSParameterAssert(templateUrl);
    NSParameterAssert(error);
    NSLog(@"Url: %@", templateUrl);
    
    /* Load the template xml document */
    NSXMLDocument* xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL: templateUrl
                                                                 options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                                   error: error];
    /* Ensure that there wasn't errors */
    if(*error != nil) {
        return NO;
    }

    /* Check for additional file notes off of the template. */
    NSArray* additionalFileNodes = [xmlDoc nodesForXPath:@"/template[1]/additional_file" error: error];
    if(*error != nil) {
        return NO;
    }
    
    /* Fetch the additional filter defined in the additionfield fields above */
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
    /* If we have additonal files, add them to the schema */
    if(mAdditionalFiles.count) {
        self.additionalFiles = [NSArray arrayWithArray:mAdditionalFiles];
    }
    
    /* From the template, grab all the simple type elements and ensure that there wasn't an error */
    NSArray* simpleTypeNodes = [xmlDoc nodesForXPath:@"/template[1]/simpletype" error: error];
    if(*error != nil) {
        return NO;
    }
    
    
    /* Iterate through the simple types found within the template */
    for(NSXMLElement* aSimpleTypeNode in simpleTypeNodes) {
        NSLog(@"Template SimpleType Name: %@", aSimpleTypeNode.name);
        
        /* Build the node for the item found in the template */
        XSSimpleType* aSimpleType = [[XSSimpleType alloc] initWithNode:aSimpleTypeNode schema:self];
        NSLog(@"Template SimpleType Name: %@", aSimpleType.name);
        NSLog(@"Template SimpleType BaseType: %@", aSimpleType.baseType);
        NSLog(@"Template SimpleType Target Class: %@", aSimpleType.targetClassName);
        
        /* For the name of the node found, check if we have that item created in our known types of the XSD*/
        XSSimpleType *existingSimpleType = _knownSimpleTypeDict[aSimpleType.name];
        
        /* Check if we have that node within out XSD provided */
        if(existingSimpleType) {
            /* For our XSD value, define the values from the template */
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
        if(qName == nil){
            NSLog(@"More Issues Still");
        }
        return [self.parentSchema typeForName:qName];
    }
    
    if(qName == nil){
        NSLog(@"More Issues");
        return nil;
    }
    
    NSParameterAssert(qName.length); //EVERYTHING has a type name
    
    NSString* typeName = qName;
    NSArray* splitPrefix = [qName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @":"]];
    
    if(splitPrefix.count > 1) {
        typeName = (NSString*) [splitPrefix objectAtIndex: 1];
    }
    
    if([typeName isEqualToString:@"BookConditionType"]){
        NSLog(@"Match");
        NSLog(@"Match");
        
    }
    
    /* Search the complexType dictionary for the type name */
    id<XSType> retType = [_knownComplexTypeDict objectForKey: typeName];
    
    /* Search the simpleType dictionary for the type name */
    if(!retType) {
        retType = [_knownSimpleTypeDict objectForKey: typeName];
    }
    
    assert(retType); //EVERYTHING has to have a type
    return retType;
}

- (NSString*)classPrefixForType:(id<XSType>)type {
    if(self.parentSchema) {
        //defer
        return [self.parentSchema classPrefixForType:type];
    }

    NSString *qName = [type name];
    if(qName == nil){
        NSLog(@"Issues");
    }
    NSParameterAssert(qName.length); //EVERYTHING has a type name
    
    NSArray* splitPrefix = [qName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @":"]];
    
    NSString *namespace;
    if(splitPrefix.count > 1) {
        namespace = (NSString*) [splitPrefix objectAtIndex: 0];
    }
    
    if(!namespace || [namespace isEqualTo:self.targetNamespace]) {
        return self.targetNamespacePrefix;
    }
    else {
        return [self.targetNamespacePrefix stringByAppendingString:namespace.capitalizedString];
    }
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
    
    //name fixes
    id newName = [[self.class knownNameChanges] objectForKey:vName];
    if(newName) {
        vName = newName;
    }
    
    assert(vName.length); //EVERYTHING has a name
    return vName;
}

#pragma mark

+ (NSDictionary *)knownNameChanges {
    static NSDictionary* knownNameChanges;
    if(!knownNameChanges) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"nameChanges" withExtension:@"xml"];
        NSData* data = [NSData dataWithContentsOfURL: url];
        NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData: data options: 0 error: nil];
        if(!doc) {
            return nil;
        }
        
        NSArray* iNodes = [[doc rootElement] nodesForXPath: @"/nameChanges/nameChange" error: nil];
//        if(!iNodes) {
//            return nil;
//        }
        
        knownNameChanges  = [NSMutableDictionary dictionaryWithCapacity:iNodes.count];
        for (NSXMLElement *element in iNodes) {
            id from = [XMLUtils node:element stringAttribute:@"from"];
            id to = [XMLUtils node:element stringAttribute:@"to"];
            [(NSMutableDictionary*)knownNameChanges setObject:to forKey:from];             
        }
    }
    return knownNameChanges;
}

#pragma mark - generator

- (BOOL) generateInto: (NSURL*) destinationFolder
             products: (XSDschemaGeneratorOptions)options
                error: (NSError**) error {
    NSParameterAssert(destinationFolder);
    NSParameterAssert(error);
    
    /* SOURCE CODE - If we want to write source code */
    if (options & XSDschemaGeneratorOptionSourceCode) {
        /* Create the path that will contain all the code */
        NSURL *srcFolderUrl = [destinationFolder URLByAppendingPathComponent:@"Sources" isDirectory:YES];
        
        /* Create the actual directory at the location defined above */
        if(![[NSFileManager defaultManager] createDirectoryAtURL:srcFolderUrl withIntermediateDirectories:NO attributes:nil error:error]) {
            BOOL isDir;
            /* Ensure that the item was created */
            if(![[NSFileManager defaultManager] fileExistsAtPath:srcFolderUrl.path isDirectory:&isDir] || !isDir) {
                return NO;
            }
        }
        /* If all is well, start writing the code into the directory we created */
        if(![self writeCodeInto:srcFolderUrl error:error]) {
            return NO;
        }
    }

    /* FRAMEWORK - If we want to write a framework */
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

/**
 *
 *
 *
 *
 */
- (BOOL) writeCodeInto: (NSURL*) destinationFolder
                 error: (NSError**) error {
    *error = nil;
    
    /* If there is no template, return that is failed */
    if(!self.complexTypeArrayType) {
        return NO;
    }
    
    /* Set up template engine with your chosen matcher. */
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    /* Start writing our classes for the complex types */
    for(XSDcomplexType* type in self.complexTypes) {
        NSLog(@"-------------");
        NSLog(@"Element Name: %@", type.name);
        NSLog(@"Element Type: %@", type.baseType);
        NSLog(@"Items to be substituted: %@", type.substitutionDict);
        
        /* Create the items for the header file */
        if (self.headerTemplateString != nil) {
            /* Generate the code from the template and from the variables */
            NSString *result = [engine processTemplate:self.headerTemplateString
                                         withVariables:type.substitutionDict];
            
            NSLog(@"Header result: %@", result);

            /* Create the header file path and write the results to it */
            NSString* headerFileName = [NSString stringWithFormat: @"%@.h", type.targetClassFileName];
            NSURL* headerFilePath = [destinationFolder URLByAppendingPathComponent: headerFileName];
            [result writeToURL: headerFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];

            /* Ensure that there was no errors for writing */
            if(*error != nil) {
                return NO;
            }
        }
        
        /* Create the items for the class file */
        if (self.classTemplateString != nil) {
            /* Generate the code from the template and the variables */
            NSString *result = [engine processTemplate: self.classTemplateString
                                         withVariables: type.substitutionDict];
            
            NSLog(@"Class result: %@", result);
            
            /* Create the class file path and write the results to it */
            NSString* classFileName = [NSString stringWithFormat: @"%@.m", type.targetClassFileName];
            NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
            [result writeToURL:classFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
            
            /* Ensure that there was no errors for writing */
            if(*error != nil) {
                return NO;
            }
        }
        
        /* Create the files for the global elements */
        if(type.globalElements.count) {
            if (self.readerHeaderTemplateString != nil) {
                /* Generate the code from the template and the variables */
                NSString *result = [engine processTemplate: self.readerHeaderTemplateString
                                             withVariables: type.substitutionDict];
                /* Create the header file path and write the results to it */
                NSString* headerFileName = [NSString stringWithFormat: @"%@+File.h", type.targetClassFileName];
                NSURL* headerFilePath = [destinationFolder URLByAppendingPathComponent: headerFileName];
                [result writeToURL: headerFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];

                /* Ensure that there was no errors for writing */
                if(*error != nil) {
                    return NO;
                }
            }
            
            if (self.readerClassTemplateString != nil) {
                /* Generate the code from the template and the variables */
                NSString *result = [engine processTemplate: self.readerClassTemplateString
                                             withVariables: type.substitutionDict];
                /* Create the class file path and write the results to it */
                NSString* classFileName = [NSString stringWithFormat: @"%@+File.m", type.targetClassFileName];
                NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
                [result writeToURL: classFilePath atomically:YES encoding: NSUTF8StringEncoding error: error];
                
                /* Ensure that there was no errors for writing */
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
