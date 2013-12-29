//
//  XSDNCName.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSDNCName.h"


@implementation XSDNCName

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithNode: (NSXMLNode*) node {
    if(self = [super init])
    {
//TODO check
        self.name = [[XMLUtils getNode: node withName: @"name"] objectValue];
    }
    return self;
}

@end
