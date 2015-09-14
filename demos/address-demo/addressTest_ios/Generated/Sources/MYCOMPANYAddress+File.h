/**
 * MYCOMPANYAddress+File.h
 * Address.xsd
 */
#import <Foundation/Foundation.h>
#import "MYCOMPANYAddress.h"

@interface MYCOMPANYAddress (File)

/* Reads a xml file specified by the given url and parses it, returning a MYCOMPANYAddress */
+ (MYCOMPANYAddress *)AddressFromURL:(NSURL *)url;

/* Reads a xml file specified by the given file path and parses it, returning a MYCOMPANYAddress */
+ (MYCOMPANYAddress *)AddressFromFile:(NSString *)path;

/* Reads xml text specified by the given data and parses it, returning a MYCOMPANYAddress */
+ (MYCOMPANYAddress *)AddressFromData:(NSData *)data;

@end
