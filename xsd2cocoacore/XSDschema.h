//
//  XSDschema.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol XSType;
@class XSDcomplexType;

@interface XSDschema : NSObject

@property (nonatomic, strong) NSURL* schemaUrl;
@property (nonatomic, strong) NSString* targetNamespace;
@property (nonatomic, strong) NSArray* complexTypes;
@property (nonatomic, strong) NSArray* includedSchemas;
@property (nonatomic, weak) XSDschema* parentSchema;

///create the scheme, loading all types and includes
- (id) initWithUrl: (NSURL*) schemaUrl prefix: (NSString*) prefix error: (NSError**) error;

@end

@interface XSDschema (/*mutable*/)

- (void) addComplexType: (XSDcomplexType*) cType; //element may add local types

@end

@interface XSDschema (/*generator*/) 

@property (nonatomic, strong) NSString* complexTypeArrayType;
@property (nonatomic, strong) NSString* readComplexTypeElementTemplate;
@property (nonatomic, strong) NSString* readerClassTemplateString;
@property (nonatomic, strong) NSString* readerHeaderTemplateString;
@property (nonatomic, strong) NSString* classTemplateString;
@property (nonatomic, strong) NSString* headerTemplateString;
@property (nonatomic, strong) NSArray* additionalFiles;
@property (nonatomic, strong) NSString* classPrefix;

//write objC
- (BOOL) generateInto: (NSURL*) destinationFolder
        usingTemplate: (NSURL*) templateUrl
  copyAdditionalFiles: (BOOL)copyAdditionalFiles
    addUmbrellaHeader: (BOOL)addUmbrellaHeader
                error: (NSError**) error;

//helper
- (id<XSType>) typeForName: (NSString*) qname; //this will only return proper type info when called during generation
+ (NSString*) variableNameFromName:(NSString*)vName multiple:(BOOL)multiple;

@end