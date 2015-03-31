
#import "WLFavdef.h"
#import <libxml/xmlreader.h>

@interface WLFavdef ()

@property(nonatomic, readwrite) NSURL *link;

@property(nonatomic, readwrite) NSString *value;

@end

@implementation WLFavdef

- (void)readAttributes:(void *)reader {
  char *linkAttrValue =
      (char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"link");
  if (linkAttrValue) {
    self.link =
        [NSURL URLWithString:[NSString stringWithCString:linkAttrValue
                                                encoding:NSUTF8StringEncoding]];
  }
}

- (id)initWithReader:(void *)reader {

  int _complexTypeXmlDept = xmlTextReaderDepth(reader);
  self = [super init];
  if (self) {

    [self readAttributes:reader];

    int _readerOk = xmlTextReaderRead(reader);
    int _currentNodeType = xmlTextReaderNodeType(reader);
    int _currentXmlDept = xmlTextReaderDepth(reader);
    while (_readerOk && _currentNodeType != XML_READER_TYPE_NONE &&
           _complexTypeXmlDept < _currentXmlDept) {
      BOOL handledInChild = NO;
      if (_currentNodeType == XML_READER_TYPE_ELEMENT ||
          _currentNodeType == XML_READER_TYPE_TEXT) {
        NSString *_currentElementName = [NSString
            stringWithCString:(const char *)xmlTextReaderConstLocalName(reader)
                     encoding:NSUTF8StringEncoding];
        if ([@"#text" isEqualToString:_currentElementName]) {
          char *contentValue = (char *)xmlTextReaderConstValue(reader);
          if (contentValue) {
            NSString *value = [NSString stringWithCString:contentValue
                                                 encoding:NSUTF8StringEncoding];
            value =
                [value stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.value = value;
          }
        } else {
          NSLog(@"Ignoring unexpected: %@", _currentElementName);
          break;
        }
      }

      _readerOk = handledInChild ? xmlTextReaderReadState(reader)
                                 : xmlTextReaderRead(reader);
      _currentNodeType = xmlTextReaderNodeType(reader);
      _currentXmlDept = xmlTextReaderDepth(reader);
    }
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  if (self.link)
    [dict setObject:self.link forKey:@"link"];

  if (self.value)
    [dict setObject:self.value forKey:@"value"];

  return dict;
}
@end
