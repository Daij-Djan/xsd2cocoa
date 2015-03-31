
#import "WLDescription.h"
#import <libxml/xmlreader.h>

@interface WLDescription ()

@property(nonatomic, readwrite) NSString *identifier;

@property(nonatomic, readwrite) NSString *value;

@end

@implementation WLDescription

- (void)readAttributes:(void *)reader {
  char *idAttrValue =
      (char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"id");
  if (idAttrValue) {
    self.identifier =
        [NSString stringWithCString:idAttrValue encoding:NSUTF8StringEncoding];
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

  if (self.identifier)
    [dict setObject:self.identifier forKey:@"identifier"];

  if (self.value)
    [dict setObject:self.value forKey:@"value"];

  return dict;
}
@end
