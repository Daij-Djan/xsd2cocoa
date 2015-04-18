//
//  XSSimpleTypeTemplate.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSSchemaNode.h"
#import "XSType.h"

@interface XSSimpleType : XSSchemaNode < XSType >

@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSString* baseType;
@property (readonly, nonatomic) NSArray* attributes;
//@property (readonly, nonatomic) NSArray* globalElements;
@property (readonly, nonatomic) NSString* targetClassName;
@property (readonly, nonatomic) NSString* arrayType;
//@property (readonly, nonatomic) NSString* readEnumerationTemplate;
@property (readonly, nonatomic) NSString* readAttributeTemplate;
@property (readonly, nonatomic) NSString* readElementTemplate;
@property (readonly, nonatomic) NSString* readValueCode;
@property (readonly, nonatomic) NSString* readPrefixCode;
@property (readonly, nonatomic) NSArray* includes;
@property (strong, nonatomic) NSArray* enumerations;

- (BOOL)supplyTemplates:(NSXMLNode*)node error:(NSError**)error;
- (NSDictionary*) substitutionDict;

- (id) initWithNode: (NSXMLElement*) node schema: (XSDschema*) schema;
- (id) initWithName: (NSString*) name baseType: (NSString*)baseType schema: (XSDschema*) schema;

//enum support
- (BOOL) hasEnumeration;
- (NSArray *) enumerationValues;
- (NSString *) enumerationName;
- (NSString *) enumerationFileName;

@end

@interface XSSimpleType ()

+ (NSArray *)knownSimpleTypesForSchema:(XSDschema*)schema;

@end