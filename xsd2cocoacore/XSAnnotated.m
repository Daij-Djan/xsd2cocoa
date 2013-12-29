//
//  XSAnnotated.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSAnnotated.h"
#import "XSDschema.h"

@implementation XSAnnotated


- (id) initWithNode: (NSXMLElement*) node schema: (XSDschema*) schema {
    self = [super initWithSchema: schema];
    if(self) {
    }
    return self;
}

@end
