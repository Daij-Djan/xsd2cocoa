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

- (id) initWithName: (NSString*) name baseType: (NSString*)baseType schema: (XSDschema*) schema {
    self = [super initWithNode:nil schema:schema];
    if (self) {
        engine = [MGTemplateEngine templateEngine];
        [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
        
        self.name = name;
        self.baseType = baseType;
    }
    
    return self;
} 

- (XSSimpleType *)typeForTemplate {
    XSSimpleType *t = self;
    
    while (!t->_targetClassName && t->_baseType) {
        XSSimpleType *nT = (XSSimpleType*)[t.schema typeForName:t->_baseType];
        if(nT == t) {
            //same type
            break;
        }
        t = nT;
    }
    
    return t;
}

- (NSString *)targetClassName {
    XSSimpleType *t = self.typeForTemplate;
    return t->_targetClassName;
}

- (NSString *)targetClassFileName {
    return self.targetClassName;
}

- (NSString *)arrayType {
    XSSimpleType *t = self.typeForTemplate;
    return t->_arrayType;
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

- (NSString *)readAttributeTemplate {
    XSSimpleType *t = self.typeForTemplate;
    return t->_readAttributeTemplate;
}

- (NSString*) readCodeForAttribute: (XSDattribute*) attribute {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: attribute forKey: @"attribute"];
    return [engine processTemplate: self.readAttributeTemplate withVariables: dict];
}


- (NSString *)readElementTemplate {
    XSSimpleType *t = self.typeForTemplate;
    return t->_readElementTemplate;
}

- (NSString*) readCodeForElement: (XSDelement*) element {
    NSDictionary* dict = [NSDictionary dictionaryWithObject: element forKey: @"element"];
    return [engine processTemplate: self.readElementTemplate withVariables: dict];
}

- (NSString *)readValueCode {
    XSSimpleType *t = self.typeForTemplate;
    return t->_readValueCode;
}

- (NSString *)readPrefixCode {
    XSSimpleType *t = self.typeForTemplate;
    return t->_readPrefixCode;
}

#pragma mark enum support

/*
 * Name:        hasEnumeration
 * Parameters:  None
 * Returns:     BOOL value that will equate to
 *              0 - NO - False.
 *              1 - YES - True
 * Description: Will check the current element to see if the element type is associated
 *              with an enumeration values.
 */
- (BOOL) hasEnumeration {
    BOOL isEnumeration = NO;
    
    /* If we have some, set return value to yes */
    if([[self enumerations] count] > 0) {
            isEnumeration = YES;
    }
    
    /* Return BOOL if we have enumerations */
    return isEnumeration;
}

- (NSArray*) enumerationValues{
    NSMutableArray *rtn = [[NSMutableArray alloc] init];
    /* Ensure that we have enumerations for this element */
    if(!self.hasEnumeration){
        return rtn;
    }
    
    /* Iterate through the enumerations to grab the value*/
    for (XSDenumeration* enumType in [self enumerations]) {
        [rtn addObject:enumType.value];
    }
    
    /* Return the populated array of values */
    return rtn;
}

- (NSString *)enumerationName {
    NSCharacterSet* illegalChars = [NSCharacterSet characterSetWithCharactersInString: @"-"];
    
    NSString* vName = [self.name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.name substringToIndex:1] uppercaseString]];
    NSRange range = [vName rangeOfCharacterFromSet: illegalChars];
    while(range.length > 0) {
        // delete illegal char
        vName = [vName stringByReplacingCharactersInRange: range withString: @""];
        // range is now at next char
        vName = [vName stringByReplacingCharactersInRange: range withString:[[vName substringWithRange: range] uppercaseString]];
        
        range = [vName rangeOfCharacterFromSet: illegalChars];
    }
    
    NSString *prefix = [self.schema classPrefixForType:self];
    NSString *rtn = [NSString stringWithFormat: @"%@%@Enum", prefix, vName];
    return rtn;
}

- (NSString *)enumerationFileName {
    return [self enumerationName];
}

- (NSDictionary*) substitutionDict {
    return [NSDictionary dictionaryWithObject:self forKey:@"type"];
}

#pragma mark

/**
 * Name:        knownSimpleTypesForSchema
 * Parameters:  the schema the types are for
 * Returns:     A list of xml data simple types defined in http://www.w3.org/TR/xmlschema-2/#built-in-datatypes
 * Details:     This public method will generate a list of known simple data
 *              types listed in the datatypes.xml file in our project.
 */
+ (NSArray *)knownSimpleTypesForSchema:(XSDschema*)schema {
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
        XSSimpleType *st = [[[self class] alloc] initWithName:name baseType:base schema:schema];
        [types addObject:st];
    }
    return types;
}

@end
