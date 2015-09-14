
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CONFIGFeatureNameEnum) {
  CONFIGFeatureNameEnumUnknown,
  CONFIGFeatureNameEnumCarManagement,
  CONFIGFeatureNameEnumMain,
  CONFIGFeatureNameEnumNetworking,
  CONFIGFeatureNameEnumOfficeSuite,
  CONFIGFeatureNameEnumAlarmClock,
  CONFIGFeatureNameEnumTrafficInformation,
  CONFIGFeatureNameEnumRSS,
  CONFIGFeatureNameEnumContactPage,
  CONFIGFeatureNameEnumPersonalHomepage

};
NSString *CONFIGFeatureNameEnumToString(CONFIGFeatureNameEnum enumType);
CONFIGFeatureNameEnum CONFIGFeatureNameEnumFromString(NSString *enumString);
