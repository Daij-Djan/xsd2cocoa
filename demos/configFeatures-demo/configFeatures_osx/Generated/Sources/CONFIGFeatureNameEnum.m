
#import "CONFIGFeatureNameEnum.h"

#define kCONFIGFeatureNameEnumNamesArray                                       \
  @[                                                                           \
    @"Unknown",                                                                \
    @"CarManagement",                                                          \
    @"Main",                                                                   \
    @"Networking",                                                             \
    @"OfficeSuite",                                                            \
    @"AlarmClock",                                                             \
    @"TrafficInformation",                                                     \
    @"RSS",                                                                    \
    @"ContactPage",                                                            \
    @"PersonalHomepage"                                                        \
  ]

NSString *CONFIGFeatureNameEnumToString(CONFIGFeatureNameEnum enumType) {
  assert(enumType < kCONFIGFeatureNameEnumNamesArray.count);
  return [kCONFIGFeatureNameEnumNamesArray objectAtIndex:enumType];
}

CONFIGFeatureNameEnum CONFIGFeatureNameEnumFromString(NSString *enumString) {
  NSUInteger enumType =
      [kCONFIGFeatureNameEnumNamesArray indexOfObject:enumString];
  assert(enumType != NSNotFound);
  return (enumType != NSNotFound) ? (CONFIGFeatureNameEnum)enumType
                                  : CONFIGFeatureNameEnumUnknown;
}
