
#import "STSimpleTypesType+File.h"
#import <libxml/xmlreader.h>

@implementation STSimpleTypesType (File)

+ (STSimpleTypesType *)SimpleTypesTypeFromURL:(NSURL *)url {
  STSimpleTypesType *obj = nil;
  xmlTextReaderPtr reader =
      xmlReaderForFile(url.absoluteString.UTF8String, NULL,
                       (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                        XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret == XML_READER_TYPE_ELEMENT) {
      obj = [[STSimpleTypesType alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }
  return obj;
}

+ (STSimpleTypesType *)SimpleTypesTypeFromFile:(NSString *)path {
  return [self SimpleTypesTypeFromURL:[NSURL fileURLWithPath:path]];
}

+ (STSimpleTypesType *)SimpleTypesTypeFromData:(NSData *)data {
  STSimpleTypesType *obj = nil;
  xmlTextReaderPtr reader =
      xmlReaderForMemory([data bytes], (int)[data length], NULL, NULL,
                         (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                          XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret > 0) {
      obj = [[STSimpleTypesType alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }
  return obj;
}

@end
