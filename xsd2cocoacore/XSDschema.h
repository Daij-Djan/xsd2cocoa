//
//  XSDschema.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSType.h"

@class MGTemplateEngine;
@class XSDcomplexType;
@class NSXMLElement;

@interface XSDschema : NSObject {
  
    
@private
    NSString* _targetNamespace;
    NSString* _classPrefix;
    NSArray* namespaces;
    NSMutableDictionary* simpleTypeDict;
    NSArray* complexTypes;
    NSString *classTemplateString;
    NSString *headerTemplateString;
    NSString *readComplexTypeElementTemplate;
    MGTemplateEngine *engine;
    NSDictionary *prefixOverrideDict;
    NSArray *_additionalFiles;
}

@property (nonatomic, strong) NSString* targetNamespace;
@property (nonatomic, strong) NSString* classPrefix;
@property (nonatomic, strong) NSString* classTemplateString;
@property (nonatomic, strong) NSString* headerTemplateString;
@property (nonatomic, strong) NSString* complexTypeArrayType;
@property (nonatomic, strong) NSString* readComplexTypeElementTemplate;
@property (nonatomic, strong) NSString* readerClassTemplateString;
@property (nonatomic, strong) NSString* readerHeaderTemplateString;
@property (nonatomic, strong) NSArray* complexTypes;
@property (nonatomic, strong) NSArray* additionalFiles;

- (id) initWithNode: (NSXMLElement*) node prefix: (NSString*) prefix error: (NSError**) error;
- (id) initWithUrl: (NSURL*) schemaUrl prefix: (NSString*) prefix error: (NSError**) error;

- (BOOL) loadTemplate: (NSURL*) templateUrl error: (NSError**) error;

- (BOOL) generateInto: (NSURL*) destinationFolder
  copyAdditionalFiles: (BOOL)copyAdditionalFiles
    addUmbrellaHeader: (BOOL)addUmbrellaHeader
                error: (NSError**) error;

- (void) addComplexType: (XSDcomplexType*) cType;

- (id<XSType>) typeForName: (NSString*) qname;
- (NSString*) prefixForXMLPrefix: (NSString*) prefix;

//helper
+ (NSString*) variableNameFromName:(NSString*)vName multiple:(BOOL)multiple;

@end
