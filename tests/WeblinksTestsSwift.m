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

@interface WeblinksTestsSwift : XSDTestCaseSwift
@end

@implementation WeblinksTestsSwift

- (void)setUp {
    self.schemaName = @"weblinks";
    self.xmlFileName = @"weblinks";
    self.expectedFiles = @[@"libxml-bridging-header.h",
                           @"WLFavdef.swift",
                           @"WLFG.swift",
                           @"WLFG+File.swift",
                           @"WLGroupdef.swift",
                           @"WLDescription.swift"];
    self.rootClassName = @"parser.WLFG";
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
