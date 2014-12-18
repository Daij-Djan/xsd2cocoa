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

@property (nonatomic, weak) XSDschema* schema;

- (id) initWithSchema: (XSDschema*) schema;

@end
