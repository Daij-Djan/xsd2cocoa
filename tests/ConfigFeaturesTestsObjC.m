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

@interface ConfigFeaturesTestsObjC : XSDTestCaseObjC
@end

@implementation ConfigFeaturesTestsObjC

+ (void)setUp {
    [self helpSetUp];
}

- (void)setUp {
    self.schemaName = @"configFeatures";
    self.xmlFileName = @"configFeatures";
    self.expectedFiles = @[@"CONFIGConfig.h",
                           @"CONFIGConfig.m",
                           @"CONFIGAdvanced.h",
                           @"CONFIGAdvanced.m",
                           @"CONFIGConfig+File.h",
                           @"CONFIGConfig+File.m",
                           @"CONFIGEnumeratedStringEnum.h",
                           @"CONFIGEnumeratedStringEnum.m",
                           @"CONFIGFeature.h",
                           @"CONFIGFeature.m",
                           @"CONFIGFeatureNameEnum.h",
                           @"CONFIGFeatureNameEnum.m",
                           @"CONFIGFeatures.h",
                           @"CONFIGFeatures.m",
                           @"configFeaturesHeaders.h",
                           @"CONFIGUserRightsEnum.h",
                           @"CONFIGUserRightsEnum.m"];
    self.rootClassName = @"CONFIGConfig";
    self.parseMethodName = @"ConfigFromURL:";
    
    [self helpSetUp];
    [super setUp];
}

//setup called before
- (void)setUpNamespaced {
    self.schemaName = @"configFeaturesNamespaced";
    self.expectedFiles = @[@"CONFIGConfig.h",
                           @"CONFIGConfig.m",
                           @"CONFIGAdvanced.h",
                           @"CONFIGAdvanced.m",
                           @"CONFIGConfig+File.h",
                           @"CONFIGConfig+File.m",
                           @"CONFIGEnumeratedStringEnum.h",
                           @"CONFIGEnumeratedStringEnum.m",
                           @"CONFIGFeature.h",
                           @"CONFIGFeature.m",
                           @"CONFIGFeatureNameEnum.h",
                           @"CONFIGFeatureNameEnum.m",
                           @"CONFIGFeatures.h",
                           @"CONFIGFeatures.m",
                           @"configFeaturesNamespaced.h",
                           @"CONFIGUserRightsEnum.h",
                           @"CONFIGUserRightsEnum.m"];
    [self helpSetUp];
}

//setup called before
- (void)setUpPrefix {
    self.prefixOverride = @"TEST";
    self.expectedFiles = @[@"TESTConfig.h",
                           @"TESTConfig.m",
                           @"TESTAdvanced.h",
                           @"TESTAdvanced.m",
                           @"TESTConfig+File.h",
                           @"TESTConfig+File.m",
                           @"TESTEnumeratedStringEnum.h",
                           @"TESTEnumeratedStringEnum.m",
                           @"TESTFeature.h",
                           @"TESTFeature.m",
                           @"TESTFeatureNameEnum.h",
                           @"TESTFeatureNameEnum.m",
                           @"TESTFeatures.h",
                           @"TESTFeatures.m",
                           @"configFeatures.h",
                           @"TESTUserRightsEnum.h",
                           @"TESTUserRightsEnum.m"];
    self.rootClassName = @"TESTConfig";
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
    NSNumber *av = [rootNode valueForKeyPath:@"advanced.value"];
    XCTAssertTrue([av isEqualToNumber:@1]);//isEqualToString:@"Main"]);

    NSArray *identifiers = [rootNode valueForKeyPath:@"features.features.identifier"];
    XCTAssertTrue([identifiers[0] isEqualToNumber:@1]);//isEqualToString:@"Main"]);
    XCTAssertTrue([identifiers[1] isEqualToNumber:@2]);//isEqualToString:@"Networing"]);
    XCTAssertTrue([identifiers[2] isEqualToNumber:@3]);//isEqualToString:@"OfficeSuite"]);
    XCTAssertTrue([identifiers[3] isEqualToNumber:@5]);//isEqualToString:@"TrafficInformation"]);
    XCTAssertTrue([identifiers[4] isEqualToNumber:@6]);//isEqualToString:@"RSS"]);
    XCTAssertTrue([identifiers[5] isEqualToNumber:@8]);//isEqualToString:@"PersonalHomepage"]);
    XCTAssertTrue([[rootNode valueForKey:@"userRights"] isEqualToNumber:@3]);//isEqualToString:@"User"]);
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
