//
//  ASDATests.m
//  ASDATests
//
//  Created by Dominik Pich on 22/12/14.
//
//

#import <Cocoa/Cocoa.h>
#import "XSDTestCaseObjC.h"
#import "XSDConverterCore.h"
#import "XSSimpleType.h"

@interface SimpleTypesTestsObjC : XSDTestCaseObjC
@end

@implementation SimpleTypesTestsObjC {
    NSDictionary *_expectedClassnames;
}

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"simpleTypes";
    self.xmlFileName = @"simpleTypes";
    self.expectedFiles = @[@"simpleTypes.h",
                           @"STSimpleTypesType.h",
                           @"STSimpleTypesType.m",
                           @"STSimpleTypesType+File.h",
                           @"STSimpleTypesType+File.m"];
    self.rootClassName = @"STSimpleTypesType";
    self.parseMethodName = @"SimpleTypesTypeFromURL:";
    
    _expectedClassnames = @{
                            @"gMonth": @"NSString",
                            @"Name": @"NSString",
                            @"double": @"NSNumber",
                            @"dateTime": @"NSDate",
                            @"date": @"NSDate",
                            @"time": @"NSDate",
                            @"IDREF": @"NSString",
                            @"string": @"NSString",
                            @"negativeInteger": @"NSNumber",
                            @"nonPositiveInteger": @"NSNumber",
                            @"unsignedShort": @"NSNumber",
                            @"gYear": @"NSString",
                            @"duration": @"NSString",
                            @"NOTATION": @"NSString",
                            @"QName": @"NSString",
                            @"ENTITY": @"NSString",
                            @"short": @"NSNumber",
                            @"gDay": @"NSString",
                            @"byte": @"NSNumber",
                            @"decimal": @"NSNumber",
                            @"anyURI": @"NSURL",
                            @"NMTOKEN": @"NSString",
                            @"integer": @"NSNumber",
                            @"unsignedInt": @"NSNumber",
                            @"gMonthDay": @"NSString",
                            @"IDREFS": @"NSString",
                            @"float": @"NSNumber",
                            @"NCName": @"NSString",
                            @"token": @"NSString",
                            @"NMTOKENS": @"NSString",
                            @"ID": @"NSString",
                            @"long": @"NSNumber",
                            @"positiveInteger": @"NSNumber",
                            @"unsignedByte": @"NSNumber",
                            @"gYearMonth": @"NSString",
                            @"language": @"NSString",
                            @"int": @"NSNumber",
                            @"boolean": @"NSNumber",
                            @"normalizedString": @"NSString",
                            @"ENTITIES": @"NSString",
                            @"nonNegativeInteger": @"NSNumber",
                            @"unsignedLong": @"NSNumber"
                            };
    [self helpSetUp];
    [super setUp];
}

- (void)tearDown {
    [self helpTearDown];
    [super tearDown];
}

+ (void)tearDown {
    [self helpTearDown];
}

- (void)assertSchema:(id)schema {
    XSDcomplexType *ct = [schema typeForName:@"SimpleTypesType"];
    XCTAssert(ct);
    XCTAssert(ct.hasAnnotations);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"simpleTypes"]);

    XCTAssert(ct.simpleTypesInUse.count==40);
}

- (void)assertParsedXML:(id)rootNode {
    [self assertParsedXML:rootNode WithPrefix:@"attribute_test"];
    [self assertParsedXML:rootNode WithPrefix:@"element_test"];
}

- (void)assertParsedXML:(id)rootNode WithPrefix:(NSString*)prefix {
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    id sRFC3339DateFormatterSubSeconds = [[NSDateFormatter alloc] init];
    [sRFC3339DateFormatterSubSeconds setLocale:enUSPOSIXLocale];
    [sRFC3339DateFormatterSubSeconds setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSXXXXX"];
    [sRFC3339DateFormatterSubSeconds setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    id sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
    [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
    [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"];
    [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateFormatter *dateOnlyFormatter = [[NSDateFormatter alloc] init];
    dateOnlyFormatter.timeStyle = NSDateFormatterFullStyle;
    dateOnlyFormatter.dateFormat = @"yyyy-MM-dd";
    dateOnlyFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.timeStyle = NSDateFormatterFullStyle;
    timeFormatter.dateFormat = @"HH:mm:ss";
    timeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_string", prefix]] isEqualToString:@"all_is_ok"]));
//    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_ENTITIES", prefix]] isEqualToString:@"all_is_ok"]));
//    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_ENTITY", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_ID", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_IDREF", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_IDREFS", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_NCName", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_NMTOKEN", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_NMTOKENS", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_NOTATION", prefix]] isEqualToString:@"st:gif"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_Name", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_QName", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[[rootNode valueForKey:[NSString stringWithFormat:@"%@_anyURI", prefix]] absoluteString] isEqualToString:@"http://www.google.com"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_boolean", prefix]] isEqualToNumber:@YES]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_byte", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_dateTime", prefix]] isEqualToDate:[sRFC3339DateFormatter dateFromString:@"2015-01-25T10:37:07Z"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_dateTime2", prefix]] isEqualToDate:[sRFC3339DateFormatterSubSeconds dateFromString:@"2015-01-25T10:37:07.0012+01:00"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_date", prefix]] isEqualToDate:[dateOnlyFormatter dateFromString:@"2015-01-25"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_time", prefix]] isEqualToDate:[timeFormatter dateFromString:@"10:37:07"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_decimal", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_double", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_duration", prefix]] isEqualToString:@"PT1004199059S"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_float", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gDay", prefix]] isEqualToString:@"---01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gMonth", prefix]] isEqualToString:@"--01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gMonthDay", prefix]] isEqualToString:@"--01-01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gYear", prefix]] isEqualToString:@"1234"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gYearMonth", prefix]] isEqualToString:@"2147483648-12Z"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_int", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_integer", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_language", prefix]] isEqualToString:@"de"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_long", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_negativeInteger", prefix]] isEqualToNumber:@(-123)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_nonNegativeInteger", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_nonPositiveInteger", prefix]] isEqualToNumber:@(-123)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_normalizedString", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_positiveInteger", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_short", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_string", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_token", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_unsignedByte", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_unsignedInt", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_unsignedLong", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_unsignedShort", prefix]] isEqualToNumber:@123]));
}

#pragma mark -

- (void)testCorrectnessParsingSchema {
    [self helpTestCorrectnessParsingSchema];
}

- (void)testTargetClassesOfSimpleTypes {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XSDcomplexType *ct = [schema typeForName:@"SimpleTypesType"];

    //the classes are only valid after loading a template
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    XCTAssert(ct.simpleTypesInUse.count==40);
    for (XSSimpleType *t in ct.simpleTypesInUse) {
        XCTAssert(t.name);
        id expectedClassname = _expectedClassnames[t.name];
        XCTAssert(expectedClassname);
        XCTAssert([t.targetClassName isEqualToString:expectedClassname], @"%@ not equal to %@ for %@", t.targetClassName, expectedClassname, t.name);
        XCTAssert([t.arrayType isEqualToString:@"NSArray"]);
    }
}

- (void)testExistenceOfReadCodeOfSimpleTypes {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XSDcomplexType *ct = [schema typeForName:@"SimpleTypesType"];
    
    //the classes are only valid after loading a template
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    XCTAssert(ct.simpleTypesInUse.count==40);
    for (XSSimpleType *t in ct.simpleTypesInUse) {
        XCTAssert(t.readAttributeTemplate);
        XCTAssert(t.readElementTemplate);
        XCTAssert(t.readValueCode);

        XCTAssert([t.readAttributeTemplate rangeOfString:@"/*TODO*/"].location == NSNotFound);
        XCTAssert([t.readElementTemplate rangeOfString:@"/*TODO*/"].location ==  NSNotFound);
        XCTAssert([t.readValueCode rangeOfString:@"/*TODO*/"].location == NSNotFound);
        //prefix is optional
    }
}

- (void)testCorrectnessGeneratingParser {
    [self helpTestCorrectnessGeneratingParser];
}

#pragma mark performance tests

- (void)testPerformanceParsingSchema {
    [self helpTestPerformanceParsingSchema];
}

- (void)testPerformanceLoadingTemplate {
    [self helpTestPerformanceLoadingTemplate];
}

- (void)testPerformanceGeneratingParser {
    [self helpTestPerformanceGeneratingParser];
}

- (void)testPerformanceParsingXML {
    [self helpTestPerformanceParsingXML];
}

@end
