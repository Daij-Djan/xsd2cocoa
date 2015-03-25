//
//  XSDAnnotation.m
//  XSDConverter
//
//  Created by Dominik Pich on 26/12/14.
//
//

#import "XSDAnnotation.h"


@interface XSDAnnotation ()

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *appInfo;
@property(nonatomic, strong) NSString *documentation;

@end

@implementation XSDAnnotation

- (id) initWithNode:(NSXMLElement*)node schema:(XSDschema*)schema {
    self = [super initWithNode:node schema:schema];
    if(self) {
        self.identifier = [[XMLUtils node:node stringAttribute:@"id"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.appInfo = [[XMLUtils node:node childWithName:@"appinfo"].stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.documentation = [[XMLUtils node:node childWithName:@"documentation"].stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if(_identifier.length || _appInfo.length || _documentation.length) {
           return self;
        }
    }
    
    return nil;
}

- (NSString*)comment {
    NSMutableArray *text = [NSMutableArray arrayWithCapacity:3];
    if(_identifier) {
        [text addObject:[NSString stringWithFormat:@"id: %@", _identifier]];
    }
    if(_appInfo) {
        [text addObject:[NSString stringWithFormat:@"appInfo: %@", _appInfo]];
    }
    if(_documentation) {
        [text addObject:_documentation];
    }
    return [text componentsJoinedByString:@"\n"];
}
@end
