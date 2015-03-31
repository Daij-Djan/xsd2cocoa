
#import "WLGroupdef.h"
#import <libxml/xmlreader.h>

#import "WLDescription.h"

@interface WLGroupdef ()

@property(nonatomic, readwrite) NSString *name;

@property(nonatomic, readwrite) WLDescription *elementDescription;

@end

@implementation WLGroupdef

- (void)readAttributes:(void *)reader {
  [super readAttributes:reader];
  char *nameAttrValue =
      (char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"name");
  if (nameAttrValue) {
    self.name = [NSString stringWithCString:nameAttrValue
                                   encoding:NSUTF8StringEncoding];
  }
}

- (id)initWithReader:(void *)reader {

  int _complexTypeXmlDept = xmlTextReaderDepth(reader);
  self = [super initWithReader:reader];
  if (self) {

    int _readerOk = 1;
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
        if ([@"description" isEqualToString:_currentElementName]) {
          self.elementDescription =
              [[WLDescription alloc] initWithReader:reader];

          handledInChild = YES;
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
  [dict setValuesForKeysWithDictionary:[super dictionary]];

  if (self.name)
    [dict setObject:self.name forKey:@"name"];

  if (self.elementDescription) {
    NSDictionary *elementDescriptionDict =
        [self.elementDescription valueForKeyPath:@"dictionary"];
    [dict setObject:elementDescriptionDict forKey:@"elementDescription"];
  }

  return dict;
}
@end
