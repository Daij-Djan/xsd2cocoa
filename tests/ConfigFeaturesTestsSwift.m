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

@interface ConfigFeaturesTestsSwift : XSDTestCaseSwift
@end

@implementation ConfigFeaturesTestsSwift

- (void)setUp {
    self.schemaName = @"configFeatures";
    self.xmlFileName = @"configFeatures";
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
    //TODO test
//    NSLog(@"%@", [rootNode performSelector:@selector(dictionary)]);

    [[rootNode valueForKey:@"addressLine1"] isEqualToString:@"adasdLine1"];
    [[rootNode valueForKey:@"addressLine2"] isEqualToString:@"tempLine2"];
    [[rootNode valueForKeyPath:@"streetInfo.direction"] isEqualToString:@"SouthBySouthWest"];
    [[rootNode valueForKeyPath:@"unitInfo.number"] isEqualToString:@"0123123123"];
}

#pragma mark -

- (void)testCorrectnessParsingSchema {
    [self helpTestCorrectnessParsingSchema];
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
