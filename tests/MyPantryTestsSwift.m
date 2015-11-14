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

@interface MyPantryTestsSwift : XSDTestCaseSwift
@end

@implementation MyPantryTestsSwift

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"MyPantry";
    self.xmlFileName = @"MyPantry";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"PFoodGroupTypeEnum.swift",
                           @"PFoodItemType.swift",
                           @"PPantryType.swift",
                           @"PPantryType+File.swift",
                           @"PShelfType.swift"];
    self.rootClassName = @"parser.PPantryType";
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
