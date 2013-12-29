//
//  XmlAccess.m
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XSSchemaNode.h"
#import "XSDschema.h"

@implementation XSSchemaNode

@synthesize schema = _schema;

- (id) init
{
    self = [super init];
    if(self) {
        self.schema = nil;
    }
    return self;
}

- (id) initWithSchema: (XSDschema*) schema {
    self = [self init];
    if(self) {
        self.schema = schema;
    }
    return self;
}

+ (NSNumber*) node: (NSXMLElement*) node boolAttribute: (NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    
    if(attrNode) {
        NSString* attrValue = [attrNode stringValue];
        return [NSNumber numberWithBool: [attrValue boolValue]];
    }
    return nil;
}

+ (NSString*) node: (NSXMLElement*) node stringAttribute: (NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    
    if(attrNode) {
        return[attrNode stringValue];
    }
    return nil;
}

+ (NSNumber*) node: (NSXMLElement*) node intAttribute: (NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    
    if(attrNode) {
        NSString* attrValue = [attrNode stringValue];
        return [NSNumber numberWithInt: [attrValue intValue]];
    }
    return nil;
}

+ (NSXMLElement*) node: (NSXMLElement*) element childWithName: (NSString*) name {
	for(NSXMLNode* child in [element children]) {
		if([child respondsToSelector:@selector(localName)] && [[child localName] isEqual: name]) {
			return (NSXMLElement*)child;
		}
		if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) {
			return (NSXMLElement*)child;
		}
	}
//	for(NSXMLNode* child in [element children]) {
//		NSXMLElement* el = [XSSchemaNode node: (NSXMLElement*)child childWithName: name];
//		if(el != nil) { return el; }
//	}
	return nil;
}


+ (NSArray*) node: (NSXMLElement*) element childrenWithName: (NSString*) name {
    NSMutableArray* children = [NSMutableArray array];
    for(NSXMLNode* child in [element children]) {
		if([child respondsToSelector:@selector(localName)] && [[child localName] isEqual: name]) {
			[children addObject: child];
		}
		else if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) {
			[children addObject: child];
		}
	}
    return children;
}

+ (NSArray*) node: (NSXMLElement*) element descendantsWithName: (NSString*) name {
    NSMutableArray* children = [NSMutableArray array];
    for(NSXMLNode* child in [element children]) {
		if([child respondsToSelector:@selector(localName)] && [[child localName] isEqual: name]) {
			[children addObject: child];
		}
		else if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) {
			[children addObject: child];
		}
        else if([child kind] == NSXMLElementKind) {
            NSArray *subs = [self node:(NSXMLElement*)child descendantsWithName:name];
            if(subs.count) {
                [children addObjectsFromArray:subs];
            }
        }
	}
    return children;
}

@end
