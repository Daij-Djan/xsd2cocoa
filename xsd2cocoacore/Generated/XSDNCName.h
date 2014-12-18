//
//  XSDNCName.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLUtils.h"


@interface XSDNCName : NSObject

@property(nonatomic, strong) NSString *name;
- (id) initWithNode: (NSXMLNode*) node;

@end
