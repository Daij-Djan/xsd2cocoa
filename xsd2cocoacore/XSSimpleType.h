//
//  XSSimpleTypeTemplate.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XSType.h"
#import "XSDattribute.h"
#import "XSDelement.h"

@class MGTemplateEngine;

@interface XSSimpleType : NSObject < XSType >{
    NSString* name;
    NSString* targetClassName;
    NSString* arrayType;
    NSString* readPrefixCode;
    NSString* readAttributeTemplate;
    NSString* readElementTemplate;
    MGTemplateEngine *engine;
    NSArray *includes;
}

- (id)initWithElement: (NSXMLElement*) element error: (NSError**) error;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* targetClassName;
@property (strong, nonatomic) NSString* arrayType;
@property (strong, nonatomic) NSString* readAttributeTemplate;
@property (strong, nonatomic) NSString* readElementTemplate;
@property (strong, nonatomic) NSString* readValueTemplate;
@property (strong, nonatomic) NSString* readPrefixCode;
@property (strong, nonatomic) NSArray* includes;



@end
