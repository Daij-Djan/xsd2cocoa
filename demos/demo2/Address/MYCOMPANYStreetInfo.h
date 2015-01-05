
#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>





@interface MYCOMPANYStreetInfo : NSObject

@property (nonatomic, readonly) NSString* direction;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* number;
@property (nonatomic, readonly) NSString* trailingDirection;


@property (nonatomic, readonly) NSDictionary* dictionary;

- (id) initWithReader: (xmlTextReaderPtr) reader;
@end

@interface MYCOMPANYStreetInfo (Subclassing)
- (void) readAttributes: (xmlTextReaderPtr) reader;
@end
	