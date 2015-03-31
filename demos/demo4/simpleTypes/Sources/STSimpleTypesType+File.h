
/**
STSimpleTypesType+File.h

simpleTypes.xsd defines a format for testing all kinds of simple types
*/
#import <Foundation/Foundation.h>

#import "STSimpleTypesType.h"

@interface STSimpleTypesType (File)

/**
reads a xml file specified by the given url and parses it, returning a
STSimpleTypesType
*/
+ (STSimpleTypesType *)SimpleTypesTypeFromURL:(NSURL *)url;

/**
reads a xml file specified by the given file path and parses it, returning a
STSimpleTypesType
*/
+ (STSimpleTypesType *)SimpleTypesTypeFromFile:(NSString *)path;

/**
reads xml text specified by the given data and parses it, returning a
STSimpleTypesType
*/
+ (STSimpleTypesType *)SimpleTypesTypeFromData:(NSData *)data;

@end
