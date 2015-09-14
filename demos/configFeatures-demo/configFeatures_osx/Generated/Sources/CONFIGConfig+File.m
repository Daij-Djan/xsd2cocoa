
#import "CONFIGConfig+File.h"
#import <libxml/xmlreader.h>

@implementation CONFIGConfig (File)

/**
 * Name:            FromURL
 * Parameters:      (NSURL*) - the location of the XML file as a NSURL
 * representation
 * Returns:         A generated CONFIGConfig object
 * Description:     Generate a CONFIGConfig object from the path
 *                  specified by the user
 */
+ (CONFIGConfig *)ConfigFromURL:(NSURL *)url {
  CONFIGConfig *obj = nil;
  xmlTextReaderPtr reader =
      xmlReaderForFile(url.absoluteString.UTF8String, NULL,
                       (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                        XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret == XML_READER_TYPE_ELEMENT) {
      obj = [[CONFIGConfig alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }
  return obj;
}

/**
 * Name:            FromFile
 * Parameters:      (NSString*) - the location of the XML file as a string
 * Returns:         A generated CONFIGConfig object
 * Description:     Generate a CONFIGConfig object from the path
 *                  specified by the user
 */
+ (CONFIGConfig *)ConfigFromFile:(NSString *)path {
  return [self ConfigFromURL:[NSURL fileURLWithPath:path]];
}

/**
 * Name:            FromData:
 * Parameters:      (NSData *)
 * Returns:         A generated CONFIGConfig object
 * Description:     Generate the CONFIGConfig object from the NSData
 *                  object generated from the XML.
 */
+ (CONFIGConfig *)ConfigFromData:(NSData *)data {
  /* Initial Setup */
  CONFIGConfig *obj = nil;
  /* Create the reader */
  xmlTextReaderPtr reader =
      xmlReaderForMemory([data bytes], (int)[data length], NULL, NULL,
                         (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                          XML_PARSE_NOERROR | XML_PARSE_NOWARNING));

  /* Ensure that we have a reader and the data within it to generate the object
   */
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret > 0) {
      obj = [[CONFIGConfig alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }

  return obj;
}

@end
