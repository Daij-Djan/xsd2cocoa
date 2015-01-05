//
//  XmlAccess.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XSDschema;

@interface XSSchemaNode : NSObject

@property (readonly, nonatomic) NSXMLElement* node;
@property (readonly, weak, nonatomic) XSDschema* schema;

- (id) initWithNode:(NSXMLElement*)node schema:(XSDschema*)schema;

- (BOOL)hasAnnotations;
- (NSArray*)annotations;
- (NSString*)comment;

@end
