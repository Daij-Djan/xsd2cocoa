
#import "CONFIGUserRightsEnum.h"

#define kCONFIGUserRightsEnumNamesArray                                        \
  @[ @"Unknown", @"Admin", @"Operator", @"Magician", @"User", @"Guest" ]

NSString *CONFIGUserRightsEnumToString(CONFIGUserRightsEnum enumType) {
  assert(enumType < kCONFIGUserRightsEnumNamesArray.count);
  return [kCONFIGUserRightsEnumNamesArray objectAtIndex:enumType];
}

CONFIGUserRightsEnum CONFIGUserRightsEnumFromString(NSString *enumString) {
  NSUInteger enumType =
      [kCONFIGUserRightsEnumNamesArray indexOfObject:enumString];
  assert(enumType != NSNotFound);
  return (enumType != NSNotFound) ? (CONFIGUserRightsEnum)enumType
                                  : CONFIGUserRightsEnumUnknown;
}
