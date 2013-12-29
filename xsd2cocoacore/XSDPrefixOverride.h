//
//  XSDPrefixOverride.h
//  xsd2cocoa
//
#import <Foundation/Foundation.h>

#import "XSDattribute.h"

@interface XSDPrefixOverride : NSObject {
    NSString* forXMLPrefix;
    NSString* toCodePrefix;
}

- (id)initWithElement: (NSXMLElement*) element error: (NSError**) error;

@property (strong, nonatomic) NSString* forXMLPrefix;
@property (strong, nonatomic) NSString* toCodePrefix;



@end
