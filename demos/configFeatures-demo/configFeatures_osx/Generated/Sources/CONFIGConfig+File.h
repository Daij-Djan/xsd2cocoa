
/**
 * CONFIGConfig+File.h
  * configFeatures.xsd defines a format for testing enumeration support
 */
#import <Foundation/Foundation.h>
#import "CONFIGConfig.h"

@interface CONFIGConfig (File)

/* Reads a xml file specified by the given url and parses it, returning a
 * CONFIGConfig */
+ (CONFIGConfig *)ConfigFromURL:(NSURL *)url;

/* Reads a xml file specified by the given file path and parses it, returning a
 * CONFIGConfig */
+ (CONFIGConfig *)ConfigFromFile:(NSString *)path;

/* Reads xml text specified by the given data and parses it, returning a
 * CONFIGConfig */
+ (CONFIGConfig *)ConfigFromData:(NSData *)data;

@end
