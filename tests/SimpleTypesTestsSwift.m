//
//  ASDATests.m
//  ASDATests
//
//  Created by Dominik Pich on 22/12/14.
//
//

#import <Cocoa/Cocoa.h>
#import "XSDTestCaseSwift.h"
#import "XSDConverterCore.h"
#import "XSSimpleType.h"

@interface XSDTestCaseSwift (readPrivate)
@property NSURL *schemaUrl;
@property NSURL *templateUrl;
@end

@interface SimpleTypesTestsSwift : XSDTestCaseSwift
@end

@implementation SimpleTypesTestsSwift {
    NSDictionary *_expectedClassnames;
}

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"simpleTypes";
    self.xmlFileName = @"simpleTypes";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"STSimpleTypesType.swift",
                           @"STSimpleTypesType+File.swift"];
    self.rootClassName = @"parser.STSimpleTypesType";
    self.parseMethodName = @"SimpleTypesTypeFromURL:";
    
    _expectedClassnames = @{
                            @"gMonth": @"String",
                            @"Name": @"String",
                            @"double": @"Double",
                            @"dateTime": @"NSDate",
                            @"date": @"NSDate",
                            @"time": @"NSDate",
                            @"IDREF": @"String",
                            @"string": @"String",
                            @"negativeInteger": @"Int",
                            @"nonPositiveInteger": @"Int",
                            @"unsignedShort": @"Int",
                            @"gYear": @"String",
                            @"duration": @"String",
                            @"NOTATION": @"String",
                            @"QName": @"String",
                            @"ENTITY": @"String",
                            @"short": @"Int",
                            @"gDay": @"String",
                            @"byte": @"Int",
                            @"decimal": @"Double",
                            @"anyURI": @"NSURL",
                            @"NMTOKEN": @"String",
                            @"integer": @"Int",
                            @"unsignedInt": @"Int",
                            @"gMonthDay": @"String",
                            @"IDREFS": @"String",
                            @"float": @"Double",
                            @"NCName": @"String",
                            @"token": @"String",
                            @"NMTOKENS": @"String",
                            @"ID": @"String",
                            @"long": @"Int",
                            @"positiveInteger": @"Int",
                            @"unsignedByte": @"Int",
                            @"gYearMonth": @"String",
                            @"language": @"String",
                            @"int": @"Int",
                            @"boolean": @"Bool",
                            @"normalizedString": @"String",
                            @"ENTITIES": @"String",
                            @"nonNegativeInteger": @"Int",
                            @"unsignedLong": @"Int"
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
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_boolean", prefix]] isEqualToNumber:@YES]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_byte", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_dateTime", prefix]] isEqualToDate:[sRFC3339DateFormatter dateFromString:@"2015-01-25T10:37:07Z"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_dateTime2", prefix]] isEqualToDate:[sRFC3339DateFormatterSubSeconds dateFromString:@"2015-01-25T10:37:07.0012+01:00"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_date", prefix]] isEqualToDate:[dateOnlyFormatter dateFromString:@"2015-01-25"]]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_time", prefix]] isEqualToDate:[timeFormatter dateFromString:@"10:37:07"]]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_decimal", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_double", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_duration", prefix]] isEqualToString:@"PT1004199059S"]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_float", prefix]] isEqualToNumber:@(12.34)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gDay", prefix]] isEqualToString:@"---01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gMonth", prefix]] isEqualToString:@"--01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gMonthDay", prefix]] isEqualToString:@"--01-01"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gYear", prefix]] isEqualToString:@"1234"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_gYearMonth", prefix]] isEqualToString:@"2147483648-12Z"]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_int", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_integer", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_language", prefix]] isEqualToString:@"de"]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_long", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_negativeInteger", prefix]] isEqualToNumber:@(-123)]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_nonNegativeInteger", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_nonPositiveInteger", prefix]] isEqualToNumber:@(-123)]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_normalizedString", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_positiveInteger", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_short", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_string", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[rootNode valueForKey:[NSString stringWithFormat:@"%@_token", prefix]] isEqualToString:@"all_is_ok"]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_unsignedByte", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_unsignedInt", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_unsignedLong", prefix]] isEqualToNumber:@123]));
    XCTAssertTrue(([[self reflect:rootNode numberForKey:[NSString stringWithFormat:@"%@_unsignedShort", prefix]] isEqualToNumber:@123]));
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
        
        id expectedArrayClassname = [NSString stringWithFormat:@"[%@]",expectedClassname];
        XCTAssert([t.arrayType isEqualToString:expectedArrayClassname]);
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
        NSLog(@"TRY %@", t.name);
        
        XCTAssert(t.readAttributeTemplate);
        XCTAssert(t.readElementTemplate);
        XCTAssert(t.readValueCode);
        
        XCTAssert([t.readAttributeTemplate rangeOfString:@"/*TODO*/"].location == NSNotFound);
        XCTAssert([t.readElementTemplate rangeOfString:@"/*TODO*/"].location ==  NSNotFound);
        XCTAssert([t.readValueCode rangeOfString:@"/*TODO*/"].location == NSNotFound);
        //prefix is optional

        NSLog(@"OK %@", t.name);
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
