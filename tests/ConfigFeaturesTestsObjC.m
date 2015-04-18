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

- (void)setUp {
    self.schemaName = @"configFeatures";
    self.xmlFileName = @"configFeatures";
    self.expectedFiles = @[@"CONFIGConfig.h",
                           @"CONFIGConfig.m",
                           @"CONFIGConfig+File.h",
                           @"CONFIGConfig+File.m",
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

- (void)tearDown {
    [self helpTearDown];
    [super tearDown];
}
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
    //    //TODO test
    //    NSLog(@"%@", [rootNode performSelector:@selector(dictionary)]);
    
    NSArray *identifiers = [rootNode valueForKeyPath:@"features.features.identifier"];
    XCTAssertTrue([identifiers[0] isEqualToNumber:@2]);//isEqualToString:@"Main"]);
    XCTAssertTrue([identifiers[1] isEqualToNumber:@3]);//isEqualToString:@"Networing"]);
    XCTAssertTrue([identifiers[2] isEqualToNumber:@4]);//isEqualToString:@"OfficeSuite"]);
    XCTAssertTrue([identifiers[3] isEqualToNumber:@6]);//isEqualToString:@"TrafficInformation"]);
    XCTAssertTrue([identifiers[4] isEqualToNumber:@7]);//isEqualToString:@"RSS"]);
    XCTAssertTrue([identifiers[5] isEqualToNumber:@9]);//isEqualToString:@"PersonalHomepage"]);
    XCTAssertTrue([[rootNode valueForKey:@"userRights"] isEqualToNumber:@4]);//isEqualToString:@"User"]);
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
