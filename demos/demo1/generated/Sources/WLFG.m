
#import "WLFG.h"
#import <libxml/xmlreader.h>

#import "WLFavdef.h"
#import "WLGroupdef.h"

@interface WLFG ()

@property(nonatomic, readwrite) NSArray *favitems;
@property(nonatomic, readwrite) NSArray *groups;

@end

@implementation WLFG

- (void)readAttributes:(void *)reader {
}

- (id)initWithReader:(void *)reader {

  int _complexTypeXmlDept = xmlTextReaderDepth(reader);
  self = [super init];
  if (self) {

    [self readAttributes:reader];

    NSMutableArray *favitemsArray = [NSMutableArray array];
    NSMutableArray *groupsArray = [NSMutableArray array];

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
        if ([@"favitem" isEqualToString:_currentElementName]) {
          [favitemsArray addObject:[[WLFavdef alloc] initWithReader:reader]];

          handledInChild = YES;
        } else if ([@"group" isEqualToString:_currentElementName]) {
          [groupsArray addObject:[[WLGroupdef alloc] initWithReader:reader]];

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

    if (favitemsArray.count)
      self.favitems = favitemsArray;
    if (groupsArray.count)
      self.groups = groupsArray;
  }
  return self;
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  if (self.favitems) {
    NSDictionary *favitemsDict = [self.favitems valueForKeyPath:@"dictionary"];
    [dict setObject:favitemsDict forKey:@"favitems"];
  }

  if (self.groups) {
    NSDictionary *groupsDict = [self.groups valueForKeyPath:@"dictionary"];
    [dict setObject:groupsDict forKey:@"groups"];
  }

  return dict;
}
@end
