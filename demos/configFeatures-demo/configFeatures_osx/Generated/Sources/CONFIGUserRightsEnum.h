
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CONFIGUserRightsEnum) {
  CONFIGUserRightsEnumUnknown,
  CONFIGUserRightsEnumAdmin,
  CONFIGUserRightsEnumOperator,
  CONFIGUserRightsEnumMagician,
  CONFIGUserRightsEnumUser,
  CONFIGUserRightsEnumGuest

};
NSString *CONFIGUserRightsEnumToString(CONFIGUserRightsEnum enumType);
CONFIGUserRightsEnum CONFIGUserRightsEnumFromString(NSString *enumString);
