
#import "CONFIGFeature.h"
#import <libxml/xmlreader.h>

@interface CONFIGFeature ()
@property(nonatomic, readwrite) CONFIGFeatureNameEnum identifier;
@property(nonatomic, readwrite) NSNumber *enabled;

@end

@implementation CONFIGFeature

/**
* Name:        readAttributes
* Parameters:  (void *) - the Libxml's xmlTextReader pointer
* Returns:     (void)
* Description: Read the attributes for the current XML element
*/
- (void)readAttributes:(void *)reader {
  const char *idAttrValue =
      (const char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"id");
  if (idAttrValue) {

    self.identifier = CONFIGFeatureNameEnumFromString(
        [NSString stringWithCString:idAttrValue encoding:NSUTF8StringEncoding]);
  }
  const char *enabledAttrValue =
      (const char *)xmlTextReaderGetAttribute(reader, (xmlChar *)"enabled");
  if (enabledAttrValue) {
    self.enabled = [NSNumber
        numberWithBool:[[NSString stringWithCString:enabledAttrValue
                                           encoding:NSUTF8StringEncoding]
                           isEqualToString:@"true"]];
  }
}

/**
 * Name:        initWithReader
 * Parameters:  (void *) - the Libxml's xmlTextReader pointer
 * Returns:     returns the classes created object
 * Description: Iterate through the XML and create the CONFIGFeature object
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
        {
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
  if (self.identifier) {
    [dict setObject:CONFIGFeatureNameEnumToString(self.identifier)
             forKey:@"ATTR_ENUM-identifier"];
  }
  if (self.enabled) {
    [dict setObject:self.enabled forKey:@"ATTR-enabled"];
  }

  return dict;
}
@end
