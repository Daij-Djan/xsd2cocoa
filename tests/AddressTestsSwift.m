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

@interface AddressTestsSwift : XSDTestCaseSwift
@end

@implementation AddressTestsSwift

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"address";
    self.xmlFileName = @"address";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"MYCOMPANYAddress.swift",
                           @"MYCOMPANYAddress+File.swift",
                           @"MYCOMPANYStreetInfo.swift",
                           @"MYCOMPANYUnitInfo.swift",
                           @"MYCOMPANYProperties.swift",
                           @"MYCOMPANYEntry.swift"];
    self.rootClassName = @"parser.MYCOMPANYAddress";
    self.parseMethodName = @"addressFromURL:";
    
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
    XSDcomplexType *ct = [schema typeForName:@"address"];
    XCTAssert(ct);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"address"]);
    
    NSArray *elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"addressLine1"]);
    XCTAssert([elementNames containsObject:@"addressLine2"]);
    XCTAssert([elementNames containsObject:@"addressMatch"]);
    XCTAssert([elementNames containsObject:@"city"]);
    XCTAssert([elementNames containsObject:@"country"]);
    XCTAssert([elementNames containsObject:@"postOfficeBox"]);
    XCTAssert([elementNames containsObject:@"state"]);
    XCTAssert([elementNames containsObject:@"streetInfo"]);
    XCTAssert([elementNames containsObject:@"streetName"]);
    XCTAssert([elementNames containsObject:@"unitInfo"]);
    XCTAssert([elementNames containsObject:@"zipCode"]);

    ct = [schema typeForName:@"StreetInfo"];
    XCTAssert(ct);
    
    elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"direction"]);
    XCTAssert([elementNames containsObject:@"name"]);
    XCTAssert([elementNames containsObject:@"number"]);
    XCTAssert([elementNames containsObject:@"trailingDirection"]);
    
    ct = [schema typeForName:@"UnitInfo"];
    XCTAssert(ct);
    
    elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"number"]);
    XCTAssert([elementNames containsObject:@"type"]);

    ct = [schema typeForName:@"Properties"];
    XCTAssert(ct);
    
    elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"entry"]);

    ct = [schema typeForName:@"Entry"];
    XCTAssert(ct);
    
    elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"key"]);
    XCTAssert([elementNames containsObject:@"value"]);

    XCTAssert(ct.schema.hasAnnotations);
}

- (void)assertParsedXML:(id)rootNode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[rootNode performSelector:@selector(addressLine1)] isEqualToString:@"adasdLine1"];
    [[rootNode performSelector:@selector(addressLine2)] isEqualToString:@"tempLine2"];
    
    id streetInfo = [rootNode performSelector:@selector(streetInfo)];
    [[streetInfo performSelector:@selector(direction)] isEqualToString:@"SouthBySouthWest"];
    id unitInfo = [rootNode performSelector:@selector(unitInfo)];
    [[unitInfo performSelector:@selector(number)] isEqualToString:@"0123123123"];
#pragma clang diagnostic pop
}

#pragma mark -

- (void)testCorrectnessParsingSchema {
    [self helpTestCorrectnessParsingSchema];
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
