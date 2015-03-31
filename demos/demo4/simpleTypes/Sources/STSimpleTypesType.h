
/**
STSimpleTypesType.h

simpleTypes.xsd defines a format for testing all kinds of simple types
*/
#import <Foundation/Foundation.h>

/**
this type contains children of all supported types
*/
@interface STSimpleTypesType : NSObject

@property(nonatomic, readonly) NSString *test_string;

@property(nonatomic, readonly) NSString *test_ENTITIES;

@property(nonatomic, readonly) NSString *test_ENTITY;

@property(nonatomic, readonly) NSString *test_ID;

@property(nonatomic, readonly) NSString *test_IDREF;

@property(nonatomic, readonly) NSString *test_IDREFS;

@property(nonatomic, readonly) NSString *test_language;

@property(nonatomic, readonly) NSString *test_Name;

@property(nonatomic, readonly) NSString *test_NCName;

@property(nonatomic, readonly) NSString *test_NMTOKEN;

@property(nonatomic, readonly) NSString *test_NMTOKENS;

@property(nonatomic, readonly) NSString *test_normalizedString;

@property(nonatomic, readonly) NSString *test_QName;

@property(nonatomic, readonly) NSString *test_token;

@property(nonatomic, readonly) NSString *test_NOTATION;

@property(nonatomic, readonly) NSNumber *test_byte;

@property(nonatomic, readonly) NSNumber *test_int;

@property(nonatomic, readonly) NSNumber *test_integer;

@property(nonatomic, readonly) NSNumber *test_long;

@property(nonatomic, readonly) NSNumber *test_negativeInteger;

@property(nonatomic, readonly) NSNumber *test_nonNegativeInteger;

@property(nonatomic, readonly) NSNumber *test_nonPositiveInteger;

@property(nonatomic, readonly) NSNumber *test_positiveInteger;

@property(nonatomic, readonly) NSNumber *test_short;

@property(nonatomic, readonly) NSNumber *test_unsignedLong;

@property(nonatomic, readonly) NSNumber *test_unsignedInt;

@property(nonatomic, readonly) NSNumber *test_unsignedShort;

@property(nonatomic, readonly) NSNumber *test_unsignedByte;

@property(nonatomic, readonly) NSNumber *test_gDay;

@property(nonatomic, readonly) NSNumber *test_gMonth;

@property(nonatomic, readonly) NSNumber *test_gMonthDay;

@property(nonatomic, readonly) NSNumber *test_gYear;

@property(nonatomic, readonly) NSNumber *test_gYearMonth;

@property(nonatomic, readonly) NSNumber *test_decimal;

@property(nonatomic, readonly) NSNumber *test_double;

@property(nonatomic, readonly) NSNumber *test_float;

@property(nonatomic, readonly) NSNumber *test_duration;

@property(nonatomic, readonly) NSNumber *test_boolean;

@property(nonatomic, readonly) NSURL *test_anyURI;

@property(nonatomic, readonly) NSDate *test_dateTime;

/**
returns a dictionary representation of this class (recursivly making
dictionaries of properties)
*/
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface STSimpleTypesType (Reading)

/**
the class's initializer used by the reader to build the object structure during
parsing (xmlTextReaderPtr at the moment)
*/
- (id)initWithReader:(void *)reader;

/**
Method that is overidden by subclasses that want to extend the base type
(xmlTextReaderPtr at the moment)
*/
- (void)readAttributes:(void *)reader;

@end
