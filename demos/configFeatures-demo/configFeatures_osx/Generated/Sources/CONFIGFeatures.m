
#import "CONFIGFeatures.h"
#import <libxml/xmlreader.h>

#import "CONFIGFeature.h"

@interface CONFIGFeatures ()

@property(nonatomic, readwrite) NSArray *features;

@end

@implementation CONFIGFeatures

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
 * Description: Iterate through the XML and create the CONFIGFeatures object
 */
- (id)initWithReader:(void *)reader {
  int _complexTypeXmlDept = xmlTextReaderDepth(reader);
  self = [super init];

  /* Customize the object */
  if (self) {
    [self readAttributes:reader];
    NSMutableArray *featuresArray = [NSMutableArray array];
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
        if ([@"feature" isEqualToString:_currentElementName]) {

          [featuresArray
              addObject:[[CONFIGFeature alloc] initWithReader:reader]];
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

    if (featuresArray.count)
      self.features = featuresArray;
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

  return dict;
}
@end
