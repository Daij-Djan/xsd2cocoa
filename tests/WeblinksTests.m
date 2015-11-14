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

@interface WeblinksTests : XSDTestCase
@end

@implementation WeblinksTests

- (void)setUp {
    self.schemaName = @"weblinks";
    self.xmlFileName = @"weblinks";
    self.expectedFiles = @[@"WLFavdef.h",
                           @"WLFavdef.m",
                           @"WLFG.h",
                           @"WLFG.m",
                           @"WLFG+File.h",
                           @"WLFG+File.m",
                           @"WLGroupdef.h",
                           @"WLGroupdef.m",
                           @"WLDescription.m",
                           @"WLDescription.h",
                           @"weblinks.h"];
    self.rootClassName = @"WLFG";
    self.parseMethodName = @"FGFromURL:";
    
    [self helpSetUp];
    [super setUp];
}

- (void)tearDown {
    [self helpTearDown];
    [super tearDown];
}
- (void)assertSchema:(id)schema {
    XSDcomplexType *ct = [schema typeForName:@"FG"];
    XCTAssert(ct);
    XCTAssert([[ct.globalElements valueForKeyPath:@"name"] containsObject:@"favourites"]);
    XCTAssert([[ct.sequenceOrChoice.elements valueForKeyPath:@"name"] containsObject:@"favitem"]);
    XCTAssert([[ct.sequenceOrChoice.elements valueForKeyPath:@"name"] containsObject:@"group"]);
    XCTAssert(ct.hasAnnotations);
    
    ct = [schema typeForName:@"favdef"];
    XCTAssert(ct);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"link"]);
    XCTAssert(ct.hasAnnotations);
    
    ct = [schema typeForName:@"groupdef"];
    XCTAssert(ct);
    XCTAssert([[schema typeForName:ct.baseType].name isEqualTo:@"FG"]);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"name"]);
    XCTAssert([[ct.sequenceOrChoice.elements valueForKeyPath:@"name"] containsObject:@"description"]);
    XCTAssert(ct.hasAnnotations);

    ct = [schema typeForName:@"description"];
    XCTAssert(ct);
    XCTAssert([[ct.attributes valueForKeyPath:@"name"] containsObject:@"id"]);
    XCTAssert(ct.hasAnnotations);
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
