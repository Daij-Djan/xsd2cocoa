
#import "CONFIGConfig.h"
#import <libxml/xmlreader.h>

#import "CONFIGFeatures.h"
#import "CONFIGAdvanced.h"

@interface CONFIGConfig ()

@property(nonatomic, readwrite) CONFIGFeatures *features;
@property(nonatomic, readwrite) CONFIGUserRightsEnum userRights;
@property(nonatomic, readwrite) CONFIGAdvanced *advanced;

@end

@implementation CONFIGConfig

/**
* Name:        readAttributes
* Parameters:  (void *) - the Libxml's xmlTextReader pointer
* Returns:     (void)
* Description: Read the attributes for the current XML element
*/
- (void)readAttributes:(void *)reader {
}

/**
 * Name:        initWithReader
 * Parameters:  (void *) - the Libxml's xmlTextReader pointer
 * Returns:     returns the classes created object
 * Description: Iterate through the XML and create the CONFIGConfig object
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
        if ([@"features" isEqualToString:_currentElementName]) {

          self.features = [[CONFIGFeatures alloc] initWithReader:reader];
          handledInChild = YES;

        } else if ([@"userRights" isEqualToString:_currentElementName]) {

          _readerOk = xmlTextReaderRead(reader);
          _currentNodeType = xmlTextReaderNodeType(reader);
          const char *userRightsElementValue =
              (const char *)xmlTextReaderConstValue(reader);
          if (userRightsElementValue) {

            self.userRights = CONFIGUserRightsEnumFromString(
                [NSString stringWithCString:userRightsElementValue
                                   encoding:NSUTF8StringEncoding]);
          }
          _readerOk = xmlTextReaderRead(reader);
          _currentNodeType = xmlTextReaderNodeType(reader);

        } else if ([@"advanced" isEqualToString:_currentElementName]) {

          self.advanced = [[CONFIGAdvanced alloc] initWithReader:reader];
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
  if (self.features) {
    NSDictionary *featuresDict = [self.features valueForKeyPath:@"dictionary"];
    [dict setObject:featuresDict forKey:@"COMPLEX-features"];
  }
  if (self.userRights) {
    [dict setObject:CONFIGUserRightsEnumToString(self.userRights)
             forKey:@"SIMPLE_ENUM-userRights"];
  }
  if (self.advanced) {
    NSDictionary *advancedDict = [self.advanced valueForKeyPath:@"dictionary"];
    [dict setObject:advancedDict forKey:@"COMPLEX-advanced"];
  }

  return dict;
}
@end
