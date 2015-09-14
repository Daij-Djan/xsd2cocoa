#import "MYCOMPANYAddress+File.h"
#import <libxml/xmlreader.h>

@implementation MYCOMPANYAddress (File)

/**
 * Name:            FromURL
 * Parameters:      (NSURL*) - the location of the XML file as a NSURL representation
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate a MYCOMPANYAddress object from the path
 *                  specified by the user
 */
+ (MYCOMPANYAddress *)AddressFromURL:(NSURL *)url {
	MYCOMPANYAddress *obj = nil;
	xmlTextReaderPtr reader = xmlReaderForFile(url.absoluteString.UTF8String,
	                                           NULL,
	                                           (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
	if (reader != nil) {
		int ret = xmlTextReaderRead(reader);
		if (ret == XML_READER_TYPE_ELEMENT) {
			obj = [[MYCOMPANYAddress alloc] initWithReader:reader];
		}
		xmlFreeTextReader(reader);
	}
	return obj;
}

/**
 * Name:            FromFile
 * Parameters:      (NSString*) - the location of the XML file as a string
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate a MYCOMPANYAddress object from the path
 *                  specified by the user
 */
+ (MYCOMPANYAddress *)AddressFromFile:(NSString *)path {
	return [self AddressFromURL:[NSURL fileURLWithPath:path]];
}

/**
 * Name:            FromData:
 * Parameters:      (NSData *)
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate the MYCOMPANYAddress object from the NSData
 *                  object generated from the XML.
 */
+ (MYCOMPANYAddress *)AddressFromData:(NSData *)data {
	/* Initial Setup */
	MYCOMPANYAddress *obj = nil;
	/* Create the reader */
	xmlTextReaderPtr reader = xmlReaderForMemory([data bytes],
	                                             (int)[data length],
	                                             NULL,
	                                             NULL,
	                                             (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));

	/* Ensure that we have a reader and the data within it to generate the object */
	if (reader != nil) {
		int ret = xmlTextReaderRead(reader);
		if (ret > 0) {
			obj = [[MYCOMPANYAddress alloc] initWithReader:reader];
		}
		xmlFreeTextReader(reader);
	}

	return obj;
}

@end
