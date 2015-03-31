
#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>

#import "MYCOMPANYAddress.h"

@interface MYCOMPANYAddress (File)

+ (MYCOMPANYAddress*)AddressFromURL:(NSURL*)url
+ (MYCOMPANYAddress*)AddressFromFile:(NSString*)path
+ (MYCOMPANYAddress*)AddressFromData:(NSData*)data

@end
	