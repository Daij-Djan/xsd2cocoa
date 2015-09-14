
/**
 * STSimpleTypesType+File.h
  * simpleTypes.xsd defines a format for testing all kinds of simple types
 */
#import <Foundation/Foundation.h>
#import "STSimpleTypesType.h"

@interface STSimpleTypesType (File)

/* Reads a xml file specified by the given url and parses it, returning a
 * STSimpleTypesType */
+ (STSimpleTypesType *)SimpleTypesTypeFromURL:(NSURL *)url;

/* Reads a xml file specified by the given file path and parses it, returning a
 * STSimpleTypesType */
+ (STSimpleTypesType *)SimpleTypesTypeFromFile:(NSString *)path;

/* Reads xml text specified by the given data and parses it, returning a
 * STSimpleTypesType */
+ (STSimpleTypesType *)SimpleTypesTypeFromData:(NSData *)data;

@end
