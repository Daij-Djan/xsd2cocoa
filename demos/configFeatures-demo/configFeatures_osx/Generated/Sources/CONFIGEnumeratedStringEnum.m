
#import "CONFIGEnumeratedStringEnum.h"

#define kCONFIGEnumeratedStringEnumNamesArray @[ @"Unknown", @"level0", @"level1", @"level2" ]

NSString *
CONFIGEnumeratedStringEnumToString(CONFIGEnumeratedStringEnum enumType) {
  assert(enumType < kCONFIGEnumeratedStringEnumNamesArray.count);
  return [kCONFIGEnumeratedStringEnumNamesArray objectAtIndex:enumType];
}

CONFIGEnumeratedStringEnum
CONFIGEnumeratedStringEnumFromString(NSString *enumString) {
  NSUInteger enumType =
      [kCONFIGEnumeratedStringEnumNamesArray indexOfObject:enumString];
  assert(enumType != NSNotFound);
  return (enumType != NSNotFound) ? (CONFIGEnumeratedStringEnum)enumType
                                  : CONFIGEnumeratedStringEnumUnknown;
}
