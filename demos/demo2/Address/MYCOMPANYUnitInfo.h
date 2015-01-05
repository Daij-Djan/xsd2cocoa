
#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>





@interface MYCOMPANYUnitInfo : NSObject

@property (nonatomic, readonly) NSString* number;
@property (nonatomic, readonly) NSString* type;


@property (nonatomic, readonly) NSDictionary* dictionary;

- (id) initWithReader: (xmlTextReaderPtr) reader;
@end

@interface MYCOMPANYUnitInfo (Subclassing)
- (void) readAttributes: (xmlTextReaderPtr) reader;
@end
	