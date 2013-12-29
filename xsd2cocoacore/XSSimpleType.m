//
//  XSSimpleTypeTemplate.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "NSXMLElement.h"
#import "XSSimpleType.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@implementation XSSimpleType

@synthesize targetClassName;
@synthesize arrayType;
@synthesize name;
@synthesize readPrefixCode;
@synthesize readAttributeTemplate;
@synthesize readElementTemplate;
@synthesize readValueTemplate;
@synthesize includes;

- (id)initWithElement: (NSXMLElement*) element error: (NSError**) error {
    self = [super init];
    if (self) {
        engine = [MGTemplateEngine templateEngine];
        [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
        
        self.targetClassName = [[element attributeForName: @"objType"] stringValue];
        self.arrayType = [[element attributeForName: @"arrayType"] stringValue];
        self.name = [[element attributeForName: @"name"] stringValue];
        
        NSArray* readPrefixNodes = [element nodesForXPath:@"read[1]/prefix[1]" error: error];
        if(*error != nil) {
            return nil;
        }
        if(readPrefixNodes.count > 0) {
            self.readPrefixCode = [[readPrefixNodes objectAtIndex: 0] stringValue];
        }
        
        NSArray* readAttributeNodes = [element nodesForXPath:@"read[1]/attribute[1]" error: error];
        if(*error != nil) {
            return nil;
        }
        if(readAttributeNodes.count > 0) {
            self.readAttributeTemplate = [[readAttributeNodes objectAtIndex: 0] stringValue];
        }
        
        NSArray* readElementNodes = [element nodesForXPath:@"read[1]/element[1]" error: error];
        if(*error != nil) {
            return nil;
        }
        if(readElementNodes.count > 0) {
            self.readElementTemplate = [[readElementNodes objectAtIndex: 0] stringValue];
        }
        
        NSArray* valueElementNodes = [element nodesForXPath:@"read[1]/value[1]" error: error];
        if(*error != nil) {
            return nil;
        }
        if(valueElementNodes.count > 0) {
            self.readValueTemplate = [[valueElementNodes objectAtIndex: 0] stringValue];
        }

        NSArray* includeElementNodes = [element nodesForXPath:@"/read[1]/include" error: error];
        if(*error != nil) {
            return nil;
        }
        if(includeElementNodes.count > 0) {
            NSMutableArray *mIncludes = [NSMutableArray array];
            for (NSXMLElement *elem in includeElementNodes) {
                [mIncludes addObject:elem.stringValue];
            }
            self.includes = [NSArray arrayWithArray:mIncludes];
        }
    }
    
    return self;
} 

- (NSString*) readCodeForAttribute: (XSDattribute*) attribute {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: attribute forKey: @"attribute"];
    return [engine processTemplate: self.readAttributeTemplate withVariables: dict];
}


- (NSString*) readCodeForElement: (XSDelement*) element {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: element forKey: @"element"];
    return [engine processTemplate: self.readElementTemplate withVariables: dict];
}

- (NSString*) readCodeForValue: (XSDelement*) element {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: element forKey: @"element"];
    return [engine processTemplate: self.readElementTemplate withVariables: dict];
}


@end
