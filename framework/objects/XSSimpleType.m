//
//  XSSimpleTypeTemplate.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSSimpleType.h"
#import "XMLUtils.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"
#import "XSDattribute.h"

@interface XSSimpleType ()
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* baseType;
@property (strong, nonatomic) NSArray* attributes;
//@property (strong, nonatomic) NSArray* globalElements;
@property (strong, nonatomic) NSString* targetClassName;
@property (strong, nonatomic) NSString* arrayType;
@property (strong, nonatomic) NSString* readAttributeTemplate;
@property (strong, nonatomic) NSString* readElementTemplate;
@property (strong, nonatomic) NSString* readValueCode;
@property (strong, nonatomic) NSString* readPrefixCode;
@property (strong, nonatomic) NSArray* includes;
@end

@implementation XSSimpleType {
    MGTemplateEngine *engine;
}

- (id) initWithNode: (NSXMLElement*) node schema: (XSDschema*) schema {
    self = [super initWithNode:node schema:schema];
    if (self) {
        engine = [MGTemplateEngine templateEngine];
        [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];

        self.name = [XMLUtils node:node stringAttribute:@"name"];

        NSArray* elementTags = [XMLUtils node: node childrenWithName: @"extension"];
        if(!elementTags)  {
            elementTags = [XMLUtils node: node childrenWithName: @"restriction"];
        }
        
        for(NSXMLElement* anElement in elementTags) {
            self.baseType = [XMLUtils node: anElement stringAttribute: @"base"];
            
            NSMutableArray* newAttributes = [NSMutableArray array];
            NSArray* attributeTags = [XMLUtils node: anElement childrenWithName: @"attribute"];
            for(NSXMLElement* anElement in attributeTags) {
                [newAttributes addObject: [[XSDattribute alloc] initWithNode: anElement schema: schema]];
            }
            self.attributes = newAttributes;
        }
    }
    
    return self;
} 

- (NSString *)targetClassFileName {
    return self.targetClassName;
}

#pragma mark template matching

- (BOOL)supplyTemplates:(NSXMLElement *)element error:(NSError *__autoreleasing *)error {
    engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    self.targetClassName = [[element attributeForName: @"baseType"] stringValue];
    self.targetClassName = [[element attributeForName: @"objType"] stringValue];
    self.arrayType = [[element attributeForName: @"arrayType"] stringValue];
    self.name = [[element attributeForName: @"name"] stringValue];
    
    NSArray* readPrefixNodes = [element nodesForXPath:@"read[1]/prefix[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readPrefixNodes.count > 0) {
        self.readPrefixCode = [[readPrefixNodes objectAtIndex: 0] stringValue];
    }
    
    NSArray* readAttributeNodes = [element nodesForXPath:@"read[1]/attribute[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readAttributeNodes.count > 0) {
        self.readAttributeTemplate = [[readAttributeNodes objectAtIndex: 0] stringValue];
    }
    
    NSArray* readElementNodes = [element nodesForXPath:@"read[1]/element[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readElementNodes.count > 0) {
        self.readElementTemplate = [[readElementNodes objectAtIndex: 0] stringValue];
    }
    
    NSArray* valueElementNodes = [element nodesForXPath:@"read[1]/value[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(valueElementNodes.count > 0) {
        self.readValueCode = [[valueElementNodes objectAtIndex: 0] stringValue];
    }
    
    NSArray* includeElementNodes = [element nodesForXPath:@"/read[1]/include" error: error];
    if(*error != nil) {
        return NO;
    }
    if(includeElementNodes.count > 0) {
        NSMutableArray *mIncludes = [NSMutableArray array];
        for (NSXMLElement *elem in includeElementNodes) {
            [mIncludes addObject:elem.stringValue];
        }
        self.includes = [NSArray arrayWithArray:mIncludes];
    }
    
    return YES;
}

- (NSString*) readCodeForAttribute: (XSDattribute*) attribute {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: attribute forKey: @"attribute"];
    return [engine processTemplate: self.readAttributeTemplate withVariables: dict];
}


- (NSString*) readCodeForElement: (XSDelement*) element {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: element forKey: @"element"];
    return [engine processTemplate: self.readElementTemplate withVariables: dict];
}

#pragma mark

+ (NSArray *)knownSimpleTypes {
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"datatypes" withExtension:@"xml"];
    NSData* data = [NSData dataWithContentsOfURL: url];
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData: data options: 0 error: nil];
    if(!doc) {
        return nil;
    }
    
    NSArray* iNodes = [[doc rootElement] nodesForXPath: @"/datatypes/type" error: nil];
    if(iNodes) {
        return nil;
    }
        
    NSMutableArray *types = [NSMutableArray arrayWithCapacity:iNodes.count];
    for (NSXMLElement *element in iNodes) {
        id base = [XMLUtils node:element stringAttribute:@"base"];
        id name = [XMLUtils node:element stringAttribute:@"name"];
        XSSimpleType *st = [[[self class] alloc] init];
        st.baseType = base;
        st.name = name;
        [types addObject:st];
    }
    return types;
}

@end
