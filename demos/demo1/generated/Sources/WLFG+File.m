
#import "WLFG+File.h"
#import <libxml/xmlreader.h>

@implementation WLFG (File)

+ (WLFG *)FGFromURL:(NSURL *)url {
  WLFG *obj = nil;
  xmlTextReaderPtr reader =
      xmlReaderForFile(url.absoluteString.UTF8String, NULL,
                       (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                        XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret == XML_READER_TYPE_ELEMENT) {
      obj = [[WLFG alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }
  return obj;
}

+ (WLFG *)FGFromFile:(NSString *)path {
  return [self FGFromURL:[NSURL fileURLWithPath:path]];
}

+ (WLFG *)FGFromData:(NSData *)data {
  WLFG *obj = nil;
  xmlTextReaderPtr reader =
      xmlReaderForMemory([data bytes], (int)[data length], NULL, NULL,
                         (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA |
                          XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
  if (reader != nil) {
    int ret = xmlTextReaderRead(reader);
    if (ret > 0) {
      obj = [[WLFG alloc] initWithReader:reader];
    }
    xmlFreeTextReader(reader);
  }
  return obj;
}

@end
