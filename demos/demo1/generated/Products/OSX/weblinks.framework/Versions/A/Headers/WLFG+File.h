
/**
WLFG+File.h

weblinks.xsd defines a format for saving links to your favourite websites
*/
#import <Foundation/Foundation.h>
//RM #import <libxml/xmlreader.h>

#import "WLFG.h"

@interface WLFG (File)

/**
reads a xml file specified by the given url and parses it, returning a WLFG
*/
+ (WLFG*)FGFromURL:(NSURL*)url;

/**
reads a xml file specified by the given file path and parses it, returning a WLFG
*/
+ (WLFG*)FGFromFile:(NSString*)path;

/**
reads xml text specified by the given data and parses it, returning a WLFG
*/
+ (WLFG*)FGFromData:(NSData*)data;

@end
	