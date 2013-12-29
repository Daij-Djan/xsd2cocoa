//
//  XSAnnotated.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSSchemaNode.h"
@class XSDschema;

@interface XSAnnotated : XSSchemaNode {
@private
    
}

- (id) initWithNode: (NSXMLElement*) node schema: (XSDschema*) schema;

@end
