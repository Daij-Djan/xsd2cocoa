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

@interface MyPantryTestsObjC : XSDTestCaseObjC
@end

@implementation MyPantryTestsObjC

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"MyPantry";
    self.xmlFileName = @"MyPantry";
    self.expectedFiles = @[@"MyPantry.h",
                           @"PFoodGroupTypeEnum.h",
                           @"PFoodGroupTypeEnum.m",
                           @"PFoodItemType.h",
                           @"PFoodItemType.m",
                           @"PPantryType.h",
                           @"PPantryType.m",
                           @"PPantryType+File.h",
                           @"PPantryType+File.m",
                           @"PShelfType.h",
                           @"PShelfType.m"];
    self.rootClassName = @"PPantryType";
    self.parseMethodName = @"PantryTypeFromURL:";
    
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
    XSDcomplexType *ct = [schema typeForName:@"PantryType"];
    XCTAssert(ct);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"Pantry"]);
    XCTAssert([[ct.sequenceOrChoice.elements valueForKeyPath:@"name"] containsObject:@"Shelf"]);
}

- (void)assertParsedXML:(id)rootNode {
    NSArray *Shelfs = [rootNode valueForKey:@"Shelfs"];
    XCTAssertEqual(Shelfs.count, 2);
    NSArray *foods1 = [Shelfs[0] valueForKeyPath:@"Foods"];
    NSArray *foods2 = [Shelfs[1] valueForKeyPath:@"Foods"];
    XCTAssertEqual(foods1.count, 1);
    XCTAssertEqual(foods2.count, 1);
    
    id n1 = [foods1[0] valueForKey:@"Name"];
    id n2 = [foods2[0] valueForKey:@"Name"];
    XCTAssertEqualObjects(n1, @"Apple");
    XCTAssertEqualObjects(n2, @"Chocolate");
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
