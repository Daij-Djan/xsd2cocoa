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
+ (NSXMLNode*) getNode: (NSXMLNode*) element withName: (NSString*) name {
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

+ (NSString*)rootNodeNameFromURL:(NSURL*)url {
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

@end