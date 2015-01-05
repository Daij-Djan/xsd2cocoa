//
//  XSType.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XSDattribute;
@class XSDelement;

@protocol XSType <NSObject>

- (NSString*) name;
- (NSString*) baseType;
- (NSArray*) attributes;

//parsing

- (NSString*) arrayType;
- (NSString*) targetClassName;
- (NSString*) targetClassFileName;

- (NSString*) readCodeForAttribute: (XSDattribute*) attribute;
- (NSString*) readCodeForElement: (XSDelement*) element;

@end
