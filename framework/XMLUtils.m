/*
 Soap.m
 Provides method for serializing and deserializing values to and from the web service.

 Authors: Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
          Karl Schulenburg, UMAI Development - Shoreditch, London UK
*/

#import "XMLUtils.h"
#import <libxml/xmlreader.h>

@implementation XMLUtils

// Gets the node from another node by name
/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSXMLNode*) getNode:(NSXMLNode*) element withName:(NSString*) name {
	for(NSXMLNode* child in [element children]) {
		if([child respondsToSelector:@selector(localName)] && [[child localName] isEqual: name]) {
			return (NSXMLNode*)child;
		}
		if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) {
			return (NSXMLNode*)child;
		}
	}
	for(NSXMLNode* child in [element children]) {
		NSXMLNode* el = [XMLUtils getNode: child withName: name];
		if(el != nil) { return el; }
	}
	return nil;
}

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSString*)rootNodeNameFromURL:(NSURL*) url {
    NSString* obj = nil;
    xmlTextReaderPtr reader = xmlReaderForFile( url.absoluteString.UTF8String,
                                               NULL,
                                               (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
    if(reader != nil) {
        int ret = xmlTextReaderRead(reader);
        if(ret == 1) {
            obj = [NSString stringWithCString:(const char*)xmlTextReaderConstLocalName(reader)
                                     encoding:NSUTF8StringEncoding];
        }
        xmlFreeTextReader(reader);
    }
    return obj;
}

#pragma mark - 

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSNumber*) node:(NSXMLElement*) node boolAttribute:(NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    
    if(attrNode) {
        NSString* attrValue = [attrNode stringValue];
        return [NSNumber numberWithBool: [attrValue boolValue]];
    }
    return nil;
}

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSString*) node:(NSXMLElement*) node stringAttribute:(NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    NSString *rtn = nil;
    
    if(attrNode) {
        rtn = [attrNode stringValue];
    }
    return rtn;
}

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSNumber*) node:(NSXMLElement*) node intAttribute:(NSString*) attribute {
    NSXMLNode* attrNode = [node attributeForName: attribute];
    
    if(attrNode) {
        NSString* attrValue = [attrNode stringValue];
        return [NSNumber numberWithInt: [attrValue intValue]];
    }
    return nil;
}

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSXMLElement*) node:(NSXMLElement*) element childWithName:(NSString*) name {
    for(NSXMLNode* child in [element children]) {
        if([child respondsToSelector:@selector(localName)] && [[child localName] isEqual: name]) {
            return (NSXMLElement*)child;
        }
        if([child respondsToSelector:@selector(name)] && [[child name] isEqual: name]) {
            return (NSXMLElement*)child;
        }
    }
    
    return nil;
}

/**
 * Name: node childrentWithName
 * Parameters: (NSXMLElement *) - the current element, (NSString *) - the assumed type to check
 * Returns: Returns the length of the children with the given name of the element
 * Details: This public method will iterate the given element looking for children with the given name
 *          and will return the array of children if they exist. Otherwise it will return an empty array
 */
+ (NSArray*) node:(NSXMLElement*) element childrenWithName:(NSString*) name {
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

/**
 * Name:
 * Parameters:
 * Returns:
 * Details:
 */
+ (NSArray*) node:(NSXMLElement*) element descendantsWithName:(NSString*) name {
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