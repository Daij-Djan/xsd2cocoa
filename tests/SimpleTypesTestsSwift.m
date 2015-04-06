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

- (void)setUp {
    self.schemaName = @"simpleTypes";
    self.xmlFileName = @"simpleTypes";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"STSimpleTypesType.swift",
                           @"STSimpleTypesType+File.swift"];
    self.rootClassName = @"STSimpleTypesType";
    self.parseMethodName = @"SimpleTypesTypeFromURL:";
    
    _expectedClassnames = @{
                            @"gMonth": @"Int",
                            @"Name": @"String",
                            @"double": @"Double",
                            @"dateTime": @"NSDate",
                            @"IDREF": @"String",
                            @"string": @"String",
                            @"negativeInteger": @"Int",
                            @"nonPositiveInteger": @"Int",
                            @"unsignedShort": @"Int",
                            @"gYear": @"Int",
                            @"duration": @"Double",
                            @"NOTATION": @"String",
                            @"QName": @"String",
                            @"ENTITY": @"String",
                            @"short": @"Int",
                            @"gDay": @"Int",
                            @"byte": @"Int",
                            @"decimal": @"Double",
                            @"anyURI": @"NSURL",
                            @"NMTOKEN": @"String",
                            @"integer": @"Int",
                            @"unsignedInt": @"Int",
                            @"gMonthDay": @"Int",
                            @"IDREFS": @"String",
                            @"float": @"Double",
                            @"NCName": @"String",
                            @"token": @"String",
                            @"NMTOKENS": @"String",
                            @"ID": @"String",
                            @"long": @"Int",
                            @"positiveInteger": @"Int",
                            @"unsignedByte": @"Int",
                            @"gYearMonth": @"Int",
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
    
    [[rootNode valueForKey:@"test_ENTITIES"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_ENTITY"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_ID"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_IDREF"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_IDREFS"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_NCName"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_NMTOKEN"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_NMTOKENS"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_NOTATION"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_Name"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_QName"] isEqualToString:@"all_is_ok"];
[[[rootNode valueForKey:@"test_anyURI"] absoluteString] isEqualToString:@"http://www.google.com"];
[[rootNode valueForKey:@"test_boolean"] isEqualToNumber:@YES];
[[rootNode valueForKey:@"test_byte"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_dateTime"] isEqualToDate:[dateFormatter dateFromString:@"2015-01-25 09:37:07 +0000"]];
[[rootNode valueForKey:@"test_decimal"] isEqualToNumber:@(12.34)];
[[rootNode valueForKey:@"test_double"] isEqualToNumber:@(12.34)];
[[rootNode valueForKey:@"test_duration"] isEqualToNumber:@(12.34)];
[[rootNode valueForKey:@"test_float"] isEqualToNumber:@(12.34)];
[[rootNode valueForKey:@"test_gDay"] isEqualToNumber:@10];
[[rootNode valueForKey:@"test_gMonth"] isEqualToNumber:@12];
[[rootNode valueForKey:@"test_gMonthDay"] isEqualToNumber:@12];
[[rootNode valueForKey:@"test_gYear"] isEqualToNumber:@1234];
[[rootNode valueForKey:@"test_gYearMonth"] isEqualToNumber:@12];
[[rootNode valueForKey:@"test_int"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_integer"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_language"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_long"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_negativeInteger"] isEqualToNumber:@(-123)];
[[rootNode valueForKey:@"test_nonNegativeInteger"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_nonPositiveInteger"] isEqualToNumber:@(-123)];
[[rootNode valueForKey:@"test_normalizedString"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_positiveInteger"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_short"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_string"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_token"] isEqualToString:@"all_is_ok"];
[[rootNode valueForKey:@"test_unsignedByte"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_unsignedInt"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_unsignedLong"] isEqualToNumber:@123];
[[rootNode valueForKey:@"test_unsignedShort"] isEqualToNumber:@123];
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
        XCTAssert(t.readAttributeTemplate);
        XCTAssert(t.readElementTemplate);
        XCTAssert(t.readValueCode);
        //prefix is optional
    }
}

- (void)testCorrectnessGeneratingParserSwift {
    [self helpTestCorrectnessGeneratingParserSwift];
}

#pragma mark performance tests

- (void)testPerformanceParsingSchema {
    [self helpTestPerformanceParsingSchema];
}

- (void)testPerformanceLoadingTemplateSwift {
    [self helpTestPerformanceLoadingTemplateSwift];
}

- (void)testPerformanceGeneratingParserSwift {
    [self helpTestPerformanceGeneratingParserSwift];
}

- (void)testPerformanceParsingXMLSwift {
    [self helpTestPerformanceParsingXMLSwift];
}

@end
