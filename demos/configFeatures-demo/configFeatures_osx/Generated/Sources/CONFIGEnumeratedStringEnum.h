
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CONFIGEnumeratedStringEnum) {
  CONFIGEnumeratedStringEnumUnknown,
  CONFIGEnumeratedStringEnum0,
  CONFIGEnumeratedStringEnum1,
  CONFIGEnumeratedStringEnum2

};
NSString *
CONFIGEnumeratedStringEnumToString(CONFIGEnumeratedStringEnum enumType);
CONFIGEnumeratedStringEnum
CONFIGEnumeratedStringEnumFromString(NSString *enumString);
