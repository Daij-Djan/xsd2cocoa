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

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"configFeatures";
    self.xmlFileName = @"configFeatures";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"CONFIGConfig.swift",
                           @"CONFIGAdvanced.swift",
                           @"CONFIGConfig+File.swift",
                           @"CONFIGEnumeratedStringEnum.swift",
                           @"CONFIGFeature.swift",
                           @"CONFIGFeatureNameEnum.swift",
                           @"CONFIGFeatures.swift",
                           @"CONFIGUserRightsEnum.swift"];
    self.rootClassName = @"parser.CONFIGConfig";
    self.parseMethodName = @"ConfigFromURL:";
    
    [self helpSetUp];
    [super setUp];
}

//setup called before
- (void)setUpNamespaced {
    self.schemaName = @"configFeaturesNamespaced";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"CONFIGConfig.swift",
                           @"CONFIGAdvanced.swift",
                           @"CONFIGConfig+File.swift",
                           @"CONFIGEnumeratedStringEnum.swift",
                           @"CONFIGFeature.swift",
                           @"CONFIGFeatureNameEnum.swift",
                           @"CONFIGFeatures.swift",
                           @"CONFIGUserRightsEnum.swift"];
    [self helpSetUp];
}

//setup called before
- (void)setUpPrefix {
    self.prefixOverride = @"TEST";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"TESTConfig.swift",
                           @"TESTAdvanced.swift",
                           @"TESTConfig+File.swift",
                           @"TESTEnumeratedStringEnum.swift",
                           @"TESTFeature.swift",
                           @"TESTFeatureNameEnum.swift",
                           @"TESTFeatures.swift",
                           @"TESTUserRightsEnum.swift"];
    self.rootClassName = @"parser.TESTConfig";
    [self helpSetUp];
}

- (void)tearDown {
    [self helpTearDown];
    [super tearDown];
}

+ (void)tearDown {
    [self helpTearDown];
}

#pragma mark -

- (void)assertSchema:(id)schema {
    XSDcomplexType *ct = [schema typeForName:@"Config"];
    XCTAssert(ct);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"config"]);
    
    NSArray *elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"features"]);
    XCTAssert([elementNames containsObject:@"userRights"]);
    
    ct = [schema typeForName:@"Features"];
    XCTAssert(ct);
    
    elementNames = [ct.sequenceOrChoice.elements valueForKeyPath:@"name"];
    XCTAssert([elementNames containsObject:@"feature"]);
    
    //---
    
    XSSimpleType *st = [schema typeForName:@"UserRights"];
    XCTAssert(st);
    XCTAssert([st hasEnumeration]);
    
    st = [schema typeForName:@"FeatureName"];
    XCTAssert(st);
    XCTAssert([st hasEnumeration]);
    
    //---
    
    XCTAssert(ct.schema.hasAnnotations);
    XCTAssert(st.schema.hasAnnotations);
}

- (void)assertParsedXML:(id)rootNode {
    NSLog(@"%@", [rootNode valueForKey:@"dictionary"]);

    id advanced = [rootNode valueForKeyPath:@"advanced"];
    NSNumber *av = [self reflect:advanced numberForKey:@"value"];
    XCTAssertTrue([av isEqualToNumber:@1]);//isEqualToString:@"Main"]);
    
    NSArray *features = [rootNode valueForKeyPath:@"features.features"];
    XCTAssertTrue([[self reflect:features[0] numberForKey:@"identifier"] isEqualToNumber:@1]);//isEqualToString:@"Main"]);
    XCTAssertTrue([[self reflect:features[1] numberForKey:@"identifier"] isEqualToNumber:@2]);//isEqualToString:@"Networing"]);
    XCTAssertTrue([[self reflect:features[2] numberForKey:@"identifier"] isEqualToNumber:@3]);//isEqualToString:@"OfficeSuite"]);
    XCTAssertTrue([[self reflect:features[3] numberForKey:@"identifier"] isEqualToNumber:@5]);//isEqualToString:@"TrafficInformation"]);
    XCTAssertTrue([[self reflect:features[4] numberForKey:@"identifier"] isEqualToNumber:@6]);//isEqualToString:@"RSS"]);
    XCTAssertTrue([[self reflect:features[5] numberForKey:@"identifier"] isEqualToNumber:@8]);//isEqualToString:@"PersonalHomepage"]);
    XCTAssertTrue([[self reflect:rootNode numberForKey:@"userRights"] isEqualToNumber:@3]);//isEqualToString:@"User"]);
}

#pragma mark - test parsing schema

- (void)testCorrectnessParsingSchema {
    [self helpTestCorrectnessParsingSchema];
}

- (void)testCorrectnessParsingNamespacedSchema {
    [self setUpNamespaced];
    [self helpTestCorrectnessParsingSchema];
}

- (void)testCorrectnessParsingSchemaWithPrefix {
    [self setUpPrefix];
    [self helpTestCorrectnessParsingSchema];
}

#pragma mark - test compiling parsers

- (void)testCorrectnessGeneratingParser {
    [self helpTestCorrectnessGeneratingParser];
}


- (void)testCorrectnessGeneratingNamespacedParser {
    [self setUpNamespaced];
    [self helpTestCorrectnessGeneratingParser];
}

- (void)testCorrectnessGeneratingParserWithPrefix {
    [self setUpPrefix];
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
