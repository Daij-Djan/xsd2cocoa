//
//  ASDATests.m
//  ASDATests
//
//  Created by Dominik Pich on 22/12/14.
//
//

#import <Cocoa/Cocoa.h>
#import "XSDTestCase.h"
#import "XSDConverterCore.h"

@interface AddressTests : XSDTestCase
@end

@implementation AddressTests

- (void)setUp {
    self.schemaName = @"address";
    self.xmlFileName = @"address";
    self.expectedFiles = @[@"address.h",
                           @"MYCOMPANYAddress.h",
                           @"MYCOMPANYAddress.m",
                           @"MYCOMPANYAddress+File.h",
                           @"MYCOMPANYAddress+File.m",
                           @"MYCOMPANYStreetInfo.h",
                           @"MYCOMPANYStreetInfo.m",
                           @"MYCOMPANYUnitInfo.h",
                           @"MYCOMPANYUnitInfo.m"];
    self.rootClassName = @"MYCOMPANYAddress";
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

    XCTAssert(ct.schema.hasAnnotations);
}

- (void)assertParsedXML:(id)rootNode {
    //TODO test
    NSLog(@"%@", [rootNode performSelector:@selector(dictionary)]);
}

#pragma mark -

- (void)testCorrectnessParsingSchema {
    [self helpTestCorrectnessParsingSchema];
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
