/*
 Soap.h
 Provides method for serializing and deserializing values to and from the web service.
 Authors:	Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
          Karl Schulenburg, UMAI Development - Shoreditch, London UK
*/

#import <Foundation/Foundation.h>

@interface XMLUtils : NSObject {
    
}

// Gets the node from another node by local name / name
+ (NSXMLNode*) getNode: (NSXMLNode*) node withName: (NSString*) localName;

// gets the root node's name of a given document
+ (NSString*)rootNodeNameFromURL:(NSURL*)url;

//additional helpers

+ (NSNumber*) node: (NSXMLElement*) node boolAttribute: (NSString*) attribute;
+ (NSString*) node: (NSXMLElement*) node stringAttribute: (NSString*) attribute;
+ (NSNumber*) node: (NSXMLElement*) node intAttribute: (NSString*) attribute;
+ (NSXMLElement*) node: (NSXMLElement*) element childWithName: (NSString*) name;

+ (NSArray*) node: (NSXMLElement*) element childrenWithName: (NSString*) name;
+ (NSArray*) node: (NSXMLElement*) element descendantsWithName: (NSString*) name;

@end
