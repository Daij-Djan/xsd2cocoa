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
+ (NSXMLNode*) getNode: (NSXMLNode*) element withName: (NSString*) localName;

// gets the root node's name of a given document
+ (NSString*)rootNodeNameFromURL:(NSURL*)url;

@end
