#import "MYCOMPANYAddress.h"
#import <libxml/xmlreader.h>

#import "MYCOMPANYProperties.h"
#import "MYCOMPANYStreetInfo.h"
#import "MYCOMPANYUnitInfo.h"

@interface MYCOMPANYAddress ()

@property (nonatomic, readwrite) NSString *addressLine1;
@property (nonatomic, readwrite) NSString *addressLine2;
@property (nonatomic, readwrite) NSNumber *addressMatch;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *country;
@property (nonatomic, readwrite) NSString *postOfficeBox;
@property (nonatomic, readwrite) NSString *state;
@property (nonatomic, readwrite) MYCOMPANYStreetInfo *streetInfo;
@property (nonatomic, readwrite) NSString *streetName;
@property (nonatomic, readwrite) MYCOMPANYUnitInfo *unitInfo;
@property (nonatomic, readwrite) NSString *zipCode;
@property (nonatomic, readwrite) MYCOMPANYProperties *properties;

@end

@implementation MYCOMPANYAddress

- (void)readAttributes:(void *)reader {
}

- (id)initWithReader:(void *)reader {
	int _complexTypeXmlDept = xmlTextReaderDepth(reader);
	self = [super init];
	if (self) {
		[self readAttributes:reader];

		int _readerOk = xmlTextReaderRead(reader);
		int _currentNodeType = xmlTextReaderNodeType(reader);
		int _currentXmlDept = xmlTextReaderDepth(reader);
		while (_readerOk && _currentNodeType != XML_READER_TYPE_NONE && _complexTypeXmlDept < _currentXmlDept) {
			BOOL handledInChild = NO;
			if (_currentNodeType == XML_READER_TYPE_ELEMENT || _currentNodeType == XML_READER_TYPE_TEXT) {
				NSString *_currentElementName = [NSString stringWithCString:(const char *)xmlTextReaderConstLocalName(reader) encoding:NSUTF8StringEncoding];
				if ([@"addressLine1" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.addressLine1 = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"addressLine2" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.addressLine2 = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"addressMatch" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.addressMatch = [NSNumber numberWithBool:[[NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding] isEqualToString:@"true"]];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"city" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.city = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"country" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.country = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"postOfficeBox" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.postOfficeBox = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"state" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.state = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"streetInfo" isEqualToString:_currentElementName]) {
					self.streetInfo = [[MYCOMPANYStreetInfo alloc] initWithReader:reader];

					handledInChild = YES;
				}
				else if ([@"streetName" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.streetName = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"unitInfo" isEqualToString:_currentElementName]) {
					self.unitInfo = [[MYCOMPANYUnitInfo alloc] initWithReader:reader];

					handledInChild = YES;
				}
				else if ([@"zipCode" isEqualToString:_currentElementName]) {
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
					self.zipCode = [NSString stringWithCString:(const char *)xmlTextReaderConstValue(reader) encoding:NSUTF8StringEncoding];
					_readerOk = xmlTextReaderRead(reader); _currentNodeType = xmlTextReaderNodeType(reader);
				}
				else if ([@"properties" isEqualToString:_currentElementName]) {
					self.properties = [[MYCOMPANYProperties alloc] initWithReader:reader];
				}
				else {
					NSLog(@"Ignoring unexpected: %@", _currentElementName);
					break;
				}
			}

			_readerOk = handledInChild ? xmlTextReaderReadState(reader) : xmlTextReaderRead(reader);
			_currentNodeType = xmlTextReaderNodeType(reader);
			_currentXmlDept = xmlTextReaderDepth(reader);
		}
	}
	return self;
}

- (NSDictionary *)dictionary {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	if (self.addressLine1) [dict setObject:self.addressLine1 forKey:@"addressLine1"];

	if (self.addressLine2) [dict setObject:self.addressLine2 forKey:@"addressLine2"];

	if (self.addressMatch) [dict setObject:self.addressMatch forKey:@"addressMatch"];

	if (self.city) [dict setObject:self.city forKey:@"city"];

	if (self.country) [dict setObject:self.country forKey:@"country"];

	if (self.postOfficeBox) [dict setObject:self.postOfficeBox forKey:@"postOfficeBox"];

	if (self.state) [dict setObject:self.state forKey:@"state"];

	if (self.streetInfo) {
		NSDictionary *streetInfoDict = [self.streetInfo valueForKeyPath:@"dictionary"];
		[dict setObject:streetInfoDict forKey:@"streetInfo"];
	}

	if (self.streetName) [dict setObject:self.streetName forKey:@"streetName"];

	if (self.unitInfo) {
		NSDictionary *unitInfoDict = [self.unitInfo valueForKeyPath:@"dictionary"];
		[dict setObject:unitInfoDict forKey:@"unitInfo"];
	}

	if (self.zipCode) [dict setObject:self.zipCode forKey:@"zipCode"];

	if (self.properties) [dict setObject:self.properties forKey:@"properties"];

	return dict;
}

@end
