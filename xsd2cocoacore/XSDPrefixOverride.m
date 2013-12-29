//
//  XSDPrefixOverride.m
//  xsd2cocoa
//
//#import "NSXMLElement.h"
#import "XSDPrefixOverride.h"

@implementation XSDPrefixOverride

@synthesize toCodePrefix;
@synthesize forXMLPrefix;

- (id)initWithElement: (NSXMLElement*) element error: (NSError**) error {
    self = [super init];
    if (self) {
        self.forXMLPrefix = [[element attributeForName: @"for"] stringValue];
        self.toCodePrefix = [[element attributeForName: @"to"] stringValue];
    }
    
    return self;
} 


@end
