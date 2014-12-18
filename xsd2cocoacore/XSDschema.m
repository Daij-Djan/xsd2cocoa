
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

#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@implementation XSDschema {
    NSArray* _namespaces;
    NSMutableDictionary* _simpleTypeDict;
}

// Called when initializing the object from a node
- (id) initWithNode: (NSXMLElement*) node prefix: (NSString*) prefix error: (NSError**) error  {
	self = [self init];
    if(self) {
        _simpleTypeDict = [NSMutableDictionary dictionary];
        
        //get namespaces of xsd
        self.targetNamespace = [[node attributeForName: @"targetNamespace"] stringValue];
        _namespaces = [node namespaces];
        
        //set class prefix
        if(prefix != nil) {
            self.classPrefix = prefix;
        } else {
            for (NSXMLNode *node in _namespaces) {
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
        
        //add types, collect global elements
        self.complexTypes = [NSMutableArray array];
        NSArray* ctNodes = [node nodesForXPath: @"/schema/complexType" error: error];
        for (NSXMLElement* aChild in ctNodes) {
            XSDcomplexType* aCT = [[XSDcomplexType alloc] initWithNode: aChild schema: self];
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
            [(NSMutableArray*)self.complexTypes addObjectsFromArray:xsd.complexTypes];
        }
    }
    
    return self;
}

#pragma mark -

- (void) addComplexType: (XSDcomplexType*) cType {
    [((NSMutableArray*)self.complexTypes) addObject: cType];
}

#pragma mark - generator

- (BOOL) loadTemplate: (NSURL*) templateUrl error: (NSError**) error {
    assert(error);
    
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
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileNode attributeForName:@"path"].stringValue];
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
        XSSimpleType* aSimpleType = [[XSSimpleType alloc] initWithElement: aSimpleTypeNode error: error];
        [_simpleTypeDict setValue: aSimpleType forKey: aSimpleType.name];
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
    
    return YES;
}

- (BOOL) generateInto: (NSURL*) destinationFolder
        usingTemplate: (NSURL*) templateUrl
  copyAdditionalFiles: (BOOL)copyAdditionalFiles
    addUmbrellaHeader: (BOOL)addUmbrellaHeader
                error: (NSError**) error {
    NSParameterAssert(destinationFolder);
    NSParameterAssert(templateUrl);
    NSParameterAssert(error);

    // Set up template engine with your chosen matcher.
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    [engine setObject:@"Hi there!" forKey:@"hello"];
    
    //load template
    if(![self loadTemplate:templateUrl error:error]) {
        return NO;
    }
    
    //add all includes
    for (XSDschema *s in self.includedSchemas) {
        BOOL br = [s generateInto:destinationFolder usingTemplate:templateUrl copyAdditionalFiles:copyAdditionalFiles addUmbrellaHeader:NO error:error];
        if(!br) {
            return NO;
        }
    }
    
    //write classes
    for(XSDcomplexType* type in self.complexTypes) {
        if (self.headerTemplateString != nil) {
            NSString *result = [engine processTemplate: self.headerTemplateString
                                         withVariables: type.substitutionDict];
            
            NSString* headerFileName = [NSString stringWithFormat: @"%@.h", type.targetClassFileName];
            NSURL* headerFilePath = [destinationFolder URLByAppendingPathComponent: headerFileName];
            [result writeToURL: headerFilePath atomically:TRUE encoding: NSUTF8StringEncoding error: error];
            if(*error != nil) {
                return NO;
            }
        }
        
        if (self.classTemplateString != nil) {
            NSString *result = [engine processTemplate: self.classTemplateString
                                         withVariables: type.substitutionDict];
            
            NSString* classFileName = [NSString stringWithFormat: @"%@.m", type.targetClassFileName];
            NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
            [result writeToURL: classFilePath atomically:TRUE encoding: NSUTF8StringEncoding error: error];
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
                [result writeToURL: headerFilePath atomically:TRUE encoding: NSUTF8StringEncoding error: error];
                if(*error != nil) {
                    return NO;
                }
            }
            
            if (self.readerClassTemplateString != nil) {
                NSString *result = [engine processTemplate: self.readerClassTemplateString
                                             withVariables: type.substitutionDict];
                
                NSString* classFileName = [NSString stringWithFormat: @"%@+File.m", type.targetClassFileName];
                NSURL* classFilePath = [destinationFolder URLByAppendingPathComponent: classFileName];
                [result writeToURL: classFilePath atomically:TRUE encoding: NSUTF8StringEncoding error: error];
                if(*error != nil) {
                    return NO;
                }
            }
        }
    }
    
    //copy additional files
    if(copyAdditionalFiles) {
        for (NSString *filePath in self.additionalFiles) {
            NSString *destPath = [destinationFolder.path stringByAppendingPathComponent:filePath.lastPathComponent];
            [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:nil];
        }
    }
    
    //add header
    if(addUmbrellaHeader) {
        NSString *fileName = [NSString stringWithFormat:@"%@.h", destinationFolder.lastPathComponent];
        NSURL *filePath = [destinationFolder URLByAppendingPathComponent:fileName];
        
        //unique the fricking name
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
            fileName = [NSString stringWithFormat:@"__%@_umbrella.h", destinationFolder.lastPathComponent];
            filePath = [destinationFolder URLByAppendingPathComponent:fileName];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath.path]) {
                fileName = [NSString stringWithFormat:@"__%@_umbrella_%lf.h", destinationFolder.lastPathComponent, [NSDate date].timeIntervalSince1970];
                filePath = [destinationFolder URLByAppendingPathComponent:fileName];
            }
        }
        
        //add includes for all other files
        NSString *includes = [self contentOfUmbrellaHeaderForFolder:destinationFolder];
        BOOL br = [includes writeToURL:filePath atomically:YES encoding:NSUTF8StringEncoding error:error];
        if(!br) {
            return NO;
        }
    }
    
    return YES;
}

- (NSString*)contentOfUmbrellaHeaderForFolder:(NSURL*)destinationFolder {
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

- (id<XSType>) typeForName: (NSString*) qName {
    assert(qName.length); //EVERYTHING has a type name
    
    NSString* typeName = qName;
    NSArray* splitPrefix = [qName componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @":"]];
    
    if(splitPrefix.count > 1) {
        typeName = (NSString*) [splitPrefix objectAtIndex: 1];
    }
    
    id<XSType> retType;
    
    for(XSDcomplexType* type in self.complexTypes) {
        if([type.name isEqual: typeName]) {
            retType = type;
            break;
        }
    }
    
    if(!retType) {
        retType = [_simpleTypeDict objectForKey: typeName];
    }
    
    //    assert(retType); //almost EVERYTHING has a type :D
    return retType;
}


#pragma mark -

+ (NSString*) variableNameFromName:(NSString*)vName multiple:(BOOL)multiple {
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

@end
