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

@interface XSDTestCaseObjC (readPrivate)
@property NSURL *schemaUrl;
@property NSURL *templateUrl;
@end

@interface SimpleTypesTestsObjC : XSDTestCaseObjC
@end

@implementation SimpleTypesTestsObjC {
    NSDictionary *_expectedClassnames;
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
                            @"gMonth": @"NSNumber",
                            @"Name": @"NSString",
                            @"double": @"NSNumber",
                            @"dateTime": @"NSDate",
                            @"IDREF": @"NSString",
                            @"string": @"NSString",
                            @"negativeInteger": @"NSNumber",
                            @"nonPositiveInteger": @"NSNumber",
                            @"unsignedShort": @"NSNumber",
                            @"gYear": @"NSNumber",
                            @"duration": @"NSNumber",
                            @"NOTATION": @"NSString",
                            @"QName": @"NSString",
                            @"ENTITY": @"NSString",
                            @"short": @"NSNumber",
                            @"gDay": @"NSNumber",
                            @"byte": @"NSNumber",
                            @"decimal": @"NSNumber",
                            @"anyURI": @"NSURL",
                            @"NMTOKEN": @"NSString",
                            @"integer": @"NSNumber",
                            @"unsignedInt": @"NSNumber",
                            @"gMonthDay": @"NSNumber",
                            @"IDREFS": @"NSString",
                            @"float": @"NSNumber",
                            @"NCName": @"NSString",
                            @"token": @"NSString",
                            @"NMTOKENS": @"NSString",
                            @"ID": @"NSString",
                            @"long": @"NSNumber",
                            @"positiveInteger": @"NSNumber",
                            @"unsignedByte": @"NSNumber",
                            @"gYearMonth": @"NSNumber",
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
- (void)assertSchema:(id)schema {
    XSDcomplexType *ct = [schema typeForName:@"SimpleTypesType"];
    XCTAssert(ct);
    XCTAssert(ct.hasAnnotations);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"simpleTypes"]);

    XCTAssert(ct.simpleTypesInUse.count==40);
}

- (void)assertParsedXML:(id)rootNode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterFullStyle;
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    XCTAssertTrue([[rootNode valueForKey:@"test_ENTITIES"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_ENTITY"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_ID"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_IDREF"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_IDREFS"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_NCName"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_NMTOKEN"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_NMTOKENS"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_NOTATION"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_Name"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_QName"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[[rootNode valueForKey:@"test_anyURI"] absoluteString] isEqualToString:@"http://www.google.com"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_boolean"] isEqualToNumber:@YES]);
    XCTAssertTrue([[rootNode valueForKey:@"test_byte"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_dateTime"] isEqualToDate:[dateFormatter dateFromString:@"2015-01-25 09:37:07 +0000"]]);
    XCTAssertTrue([[rootNode valueForKey:@"test_decimal"] isEqualToNumber:@(12.34)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_double"] isEqualToNumber:@(12.34)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_duration"] isEqualToNumber:@(12.34)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_float"] isEqualToNumber:@(12.34)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_gDay"] isEqualToNumber:@10]);
    XCTAssertTrue([[rootNode valueForKey:@"test_gMonth"] isEqualToNumber:@12]);
    XCTAssertTrue([[rootNode valueForKey:@"test_gMonthDay"] isEqualToNumber:@12]);
    XCTAssertTrue([[rootNode valueForKey:@"test_gYear"] isEqualToNumber:@1234]);
    XCTAssertTrue([[rootNode valueForKey:@"test_gYearMonth"] isEqualToNumber:@12]);
    XCTAssertTrue([[rootNode valueForKey:@"test_int"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_integer"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_language"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_long"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_negativeInteger"] isEqualToNumber:@(-123)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_nonNegativeInteger"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_nonPositiveInteger"] isEqualToNumber:@(-123)]);
    XCTAssertTrue([[rootNode valueForKey:@"test_normalizedString"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_positiveInteger"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_short"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_string"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_token"] isEqualToString:@"all_is_ok"]);
    XCTAssertTrue([[rootNode valueForKey:@"test_unsignedByte"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_unsignedInt"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_unsignedLong"] isEqualToNumber:@123]);
    XCTAssertTrue([[rootNode valueForKey:@"test_unsignedShort"] isEqualToNumber:@123]);
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
        XCTAssert([t.targetClassName isEqualToString:expectedClassname]);
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
        //prefix is optional
    }
}

- (void)testCorrectnessGeneratingParserObjC {
    [self helpTestCorrectnessGeneratingParserObjC];
}

#pragma mark performance tests

- (void)testPerformanceParsingSchema {
    [self helpTestPerformanceParsingSchema];
}

- (void)testPerformanceLoadingTemplateObjC {
    [self helpTestPerformanceLoadingTemplateObjC];
}

- (void)testPerformanceGeneratingParserObjC {
    [self helpTestPerformanceGeneratingParserObjC];
}

- (void)testPerformanceParsingXMLObjC {
    [self helpTestPerformanceParsingXMLObjC];
}

@end
