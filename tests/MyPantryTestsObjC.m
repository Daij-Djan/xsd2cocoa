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
    self.expectedFiles = @[@"LangDefType.h",
                           @"LangDefType.m",
                           @"LangDefType+File.h",
                           @"LangDefType+File.m",
                           @"LangIDType.h",
                           @"LangIDType.m",
                           @"SampleLanguageData.h"];
    self.rootClassName = @"LangDefType";
    self.parseMethodName = @"LangDefTypeFromURL:";
    
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
    XSDcomplexType *ct = [schema typeForName:@"LangDefType"];
    XCTAssert(ct);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"LangDef"]);
    XCTAssert([[ct.sequenceOrChoice.elements valueForKeyPath:@"name"] containsObject:@"LangID"]);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"langCode"]);
    XCTAssert(ct.hasAnnotations);
    
    ct = [schema typeForName:@"LangIDType"];
    XCTAssert(ct);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"ID"]);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"Text"]);
    XCTAssert(ct.hasAnnotations);
}

- (void)assertParsedXML:(id)rootNode {
    NSString *langCode = [rootNode valueForKey:@"langCode"];

    NSArray *LangIDs = [rootNode valueForKey:@"LangIDs"];
    XCTAssertEqual(LangIDs.count, 7);
    NSArray *IDs = [LangIDs valueForKeyPath:@"ID"];
    NSArray *Texts = [LangIDs valueForKeyPath:@"Text"];
    XCTAssertEqual(IDs.count, Texts.count);
    
    NSString *first_name = nil;
    NSString *lastentry = nil;
    for(int i = 0; i < IDs.count; i++) {
        if([IDs[i] isEqualToString:@"first_name"])
            first_name = Texts[i];
        if([IDs[i] isEqualToString:@"lastentry"])
            lastentry = Texts[i];
    }
    
    XCTAssertTrue([langCode isEqualToString:@"0407"]);
    XCTAssertTrue([first_name isEqualToString:@"dominik"]);
    XCTAssertTrue([lastentry isEqualToString:@"zz"]);
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
