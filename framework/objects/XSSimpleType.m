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
#import "XSDenumeration.h"
#import "XSDschema.h"

@interface XSSimpleType ()
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* baseType;
@property (strong, nonatomic) NSArray* attributes;
//@property (strong, nonatomic) NSArray* globalElements;
@property (strong, nonatomic) NSString* targetClassName;
@property (strong, nonatomic) NSString* arrayType;
//@property (strong, nonatomic) NSString* readEnumerationTemplate;
@property (strong, nonatomic) NSString* readAttributeTemplate;
@property (strong, nonatomic) NSString* readElementTemplate;
@property (strong, nonatomic) NSString* readValueCode;
@property (strong, nonatomic) NSString* readPrefixCode;
@property (strong, nonatomic) NSArray* includes;


@end

@implementation XSSimpleType {
    MGTemplateEngine *engine;
}

- (id) initWithNode:(NSXMLElement*)node schema:(XSDschema*)schema {
    self = [super initWithNode:node schema:schema];
    /* Continute to add items to the extended XSSchemaNode class */
    if (self) {
        /* Setup the engine for the templating */
        engine = [MGTemplateEngine templateEngine];
        [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
        
        /* Grab the name from the current element */
        self.name = [XMLUtils node:node stringAttribute:@"name"];
        
        /* Check if the element is an extension or a restriction */
        NSArray* elementTags = [XMLUtils node: node childrenWithName: @"extension"];
        if([elementTags count] == 0)  {
            elementTags = [XMLUtils node:node childrenWithName: @"restriction"];
        }
        
        /* Iterate through the children of the element tag (if there are any)*/
        for(NSXMLElement* anElement in elementTags) {
            /* Set the baseType here */
            self.baseType = [XMLUtils node:anElement stringAttribute:@"base"];
            
            /* Check if we have an enumeration and assign it to our simpleType object */
            NSMutableArray* newEnumerations = [NSMutableArray array];
            NSArray* enumerationTags = [XMLUtils node:anElement childrenWithName:@"enumeration"];
            for(NSXMLElement* anElement in enumerationTags) {
                [newEnumerations addObject: [[XSDenumeration alloc] initWithNode:anElement schema:schema]];
            }
            
            /* Assign the list of enumerations that we have found to the simply type element */
            self.enumerations = newEnumerations;

            /* Check if we have attributes for this element and assign it to the element */
            NSMutableArray* newAttributes = [NSMutableArray array];
            NSArray* attributeTags = [XMLUtils node:anElement childrenWithName:@"attribute"];
            for(NSXMLElement* anElement in attributeTags) {
                [newAttributes addObject: [[XSDattribute alloc] initWithNode:anElement schema:schema]];
            }
            
            /* Assign the list of attributes that we have found to the simply type element */
            self.attributes = newAttributes;
        }
    }
    
    return self;
} 

- (NSString *)targetClassFileName {
    return self.targetClassName;
}

#pragma mark template matching
/**
 * Name: supplyTemplate
 * Parameters:  (NSXMLElement *) - the element from the template that is used in the XSD. (NSError *) - For error handling
 * Returns:     If it was successful in writing the items to the object
 * Description: When given the template value, iterate through the simpleType in the template
 *              and grab the values about the element type that will define the Objective-C code
 *              and assign it to the object that it is pointed at
 */
- (BOOL)supplyTemplates:(NSXMLElement *)element error:(NSError *__autoreleasing *)error {
    engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    self.targetClassName = [[element attributeForName: @"baseType"] stringValue];
    self.targetClassName = [[element attributeForName: @"objType"] stringValue];
    self.arrayType = [[element attributeForName: @"arrayType"] stringValue];
    self.name = [[element attributeForName: @"name"] stringValue];
    
    /* Grab the prefix from the matching element type in our template to the current simple type in our XSD */
    NSArray* readPrefixNodes = [element nodesForXPath:@"read[1]/prefix[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readPrefixNodes.count > 0) {
        self.readPrefixCode = [[readPrefixNodes objectAtIndex: 0] stringValue];
    }
    /*  */
    NSArray* readAttributeNodes = [element nodesForXPath:@"read[1]/attribute[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readAttributeNodes.count > 0) {
        NSString* temp  = [[readAttributeNodes objectAtIndex: 0] stringValue];
        self.readAttributeTemplate = temp;
    }
    /*  */
    NSArray* readElementNodes = [element nodesForXPath:@"read[1]/element[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(readElementNodes.count > 0) {
        self.readElementTemplate = [[readElementNodes objectAtIndex: 0] stringValue];
    }
    /*  */
    NSArray* valueElementNodes = [element nodesForXPath:@"read[1]/value[1]" error: error];
    if(*error != nil) {
        return NO;
    }
    if(valueElementNodes.count > 0) {
        self.readValueCode = [[valueElementNodes objectAtIndex: 0] stringValue];
    }
    /*  */
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

//- (NSString *) readCodeForEnumeration:(XSDenumeration *)enumeration{
//    NSString *rtn;
//    NSDictionary* dict = [NSDictionary dictionaryWithObject:enumeration forKey:@"enumeration"];
//    rtn =  [engine processTemplate:self.readEnumerationTemplate withVariables: dict];
//    return rtn;
//}

- (NSString*) readCodeForAttribute:(XSDattribute*) attribute {
    NSString *rtn;
    NSDictionary* dict = [NSDictionary dictionaryWithObject:attribute forKey:@"attribute"];
    rtn = [engine processTemplate:self.readAttributeTemplate withVariables: dict];
    return rtn;
}


- (NSString*) readCodeForElement:(XSDelement*) element {
    NSString* rtn;
    @try {
        /* Create a dictionary for the xsd element on the key element */
        NSDictionary* dict = [NSDictionary dictionaryWithObject:element forKey:@"element"];
        
        /* Generate the code for this element using the template for the element */
        rtn = [engine processTemplate:self.readElementTemplate withVariables:dict];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {}
   
    return rtn;
}

#pragma mark
/**
 * Name:        knownSimpleTypes
 * Parameters:  None
 * Returns:     A list of xml data simple types defined in http://www.w3.org/TR/xmlschema-2/#built-in-datatypes
 * Details:     This public method will generate a list of known simple data
 *              types listed in the datatypes.xml file in our project.
 */
+ (NSArray *)knownSimpleTypes {
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"datatypes" withExtension:@"xml"];
    NSData* data = [NSData dataWithContentsOfURL: url];
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithData:data options:0 error:nil];
    if(!doc) {
        return nil;
    }
    
    /* Select all element types of the root element datatype */
    NSArray* iNodes = [[doc rootElement] nodesForXPath:@"/datatypes/type" error:nil];

    
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
