//
//  XSDschema.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "XSSchemaNode.h"

@protocol XSType;
@class XSDcomplexType;
@class DDUncrustifyFormatter;

typedef enum : NSUInteger {
//    XSDschemaGeneratorOptionDynamicFramework=2,
//    XSDschemaGeneratorOptionStaticFramework=4,
    XSDschemaGeneratorOptionSourceCode=8,
} XSDschemaGeneratorOptions;

@interface XSDschema : XSSchemaNode

@property (readonly, nonatomic) NSURL* schemaUrl;
@property (readonly, nonatomic) NSString* targetNamespace;
@property (readonly, nonatomic) NSArray* allNamespaces;
@property (readonly, nonatomic) NSArray* complexTypes;
@property (readonly, nonatomic) NSArray* includedSchemas;//included and imported both. except for namespacing, we dont care
@property (readonly, nonatomic) NSArray* simpleTypes;

@property (readonly, weak, nonatomic) XSDschema* parentSchema;

//create the scheme, loading all types and includes
- (id) initWithUrl: (NSURL*) schemaUrl targetNamespacePrefix: (NSString*) prefix error: (NSError**) error;

//element may add local types (Complex or simple)
- (void) addType: (id<XSType>)type;

//templating
@property (readonly, nonatomic) NSString* complexTypeArrayType;
@property (readonly, nonatomic) NSString* readComplexTypeElementTemplate;
@property (readonly, nonatomic) NSString* readerClassTemplateString;
@property (readonly, nonatomic) NSString* readerHeaderTemplateString;
@property (readonly, nonatomic) NSString* classTemplateString;
@property (readonly, nonatomic) NSString* headerTemplateString;
@property (readonly, nonatomic) NSDictionary* additionalFiles;//keys=dest, values=src
@property (readonly, nonatomic) DDUncrustifyFormatter* formatter;

- (BOOL) loadTemplate: (NSURL*) templateUrl error: (NSError**) error;
- (id<XSType>) typeForName: (NSString*) qname; //this will only return proper type info when called during generation
- (NSString*)classPrefixForType:(id<XSType>)type;
+ (NSString*) variableNameFromName:(NSString*)vName multiple:(BOOL)multiple;

#pragma mark -

//generate code using loaded template
- (BOOL) generateInto: (NSURL*) destinationFolder
             products: (XSDschemaGeneratorOptions)options
                error: (NSError**) error;

@end