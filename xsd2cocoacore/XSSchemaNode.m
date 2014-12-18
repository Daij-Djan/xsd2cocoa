//
//  XmlAccess.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSSchemaNode.h"
#import "XSDschema.h"

@implementation XSSchemaNode

- (id) init
{
    self = [super init];
    if(self) {
        self.schema = nil;
    }
    return self;
}

- (id) initWithSchema: (XSDschema*) schema {
    self = [self init];
    if(self) {
        self.schema = schema;
    }
    return self;
}

@end
