
#import "CONFIGAdvanced.h"
#import <libxml/xmlreader.h>

@interface CONFIGAdvanced ()
@property(nonatomic, readwrite) NSString *name;

@property(nonatomic, readwrite) CONFIGEnumeratedStringEnum value;

@end

@implementation CONFIGAdvanced

/**
* Name:        readAttributes
* Parameters:  (void *) - the Libxml's xmlTextReader pointer
* Returns:     (void)
* Description: Read the attributes for the current XML element
*/
- (void)readAttributes:(void *)reader {
  const char *nameAttrValue =
      (const char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"name");
  if (nameAttrValue) {
    self.name = [NSString stringWithCString:nameAttrValue
                                   encoding:NSUTF8StringEncoding];
  }
}

/**
 * Name:        initWithReader
 * Parameters:  (void *) - the Libxml's xmlTextReader pointer
 * Returns:     returns the classes created object
 * Description: Iterate through the XML and create the CONFIGAdvanced object
 */
- (id)initWithReader:(void *)reader {
  int _complexTypeXmlDept = xmlTextReaderDepth(reader);
  self = [super init];

  /* Customize the object */
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
          const char *contentValue =
              (const char *)xmlTextReaderConstValue(reader);
          if (contentValue) {
            NSString *value = [NSString stringWithCString:contentValue
                                                 encoding:NSUTF8StringEncoding];
            value =
                [value stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.value = CONFIGEnumeratedStringEnumFromString(value);
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

/**
 * Name:            dictionary
 * Parameters:
 * Returns:         Populated dictionary
 * Description:     Populate the dictionary from the simpleType names within our
 * XSD
 */
- (NSDictionary *)dictionary {
  /* Initial setup */
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  /* Populate the dictionary */
  if (self.name) {
    [dict setObject:self.name forKey:@"ATTR-name"];
  }
  if (self.value) {
    [dict setObject:CONFIGEnumeratedStringEnumToString(self.value)
             forKey:@"value"];
  }

  return dict;
}
@end
