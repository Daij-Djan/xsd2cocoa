
#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>



@class MYCOMPANYStreetInfo
@class MYCOMPANYUnitInfo


@interface MYCOMPANYAddress : NSObject

@property (nonatomic, readonly) NSString* addressLine1
@property (nonatomic, readonly) NSString* addressLine2
@property (nonatomic, readonly) NSNumber* addressMatch
@property (nonatomic, readonly) NSString* city
@property (nonatomic, readonly) NSString* country
@property (nonatomic, readonly) NSString* postOfficeBox
@property (nonatomic, readonly) NSString* state
@property (nonatomic, readonly) MYCOMPANYStreetInfo* streetInfo
@property (nonatomic, readonly) NSString* streetName
@property (nonatomic, readonly) MYCOMPANYUnitInfo* unitInfo
@property (nonatomic, readonly) NSString* zipCode


@property (nonatomic, readonly) NSDictionary* dictionary

- (id) initWithReader: (xmlTextReaderPtr) reader
@end

@interface MYCOMPANYAddress (Subclassing)
- (void) readAttributes: (xmlTextReaderPtr) reader
@end
	