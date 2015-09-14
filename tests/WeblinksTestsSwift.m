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

+ (void)setUp {
    [self helpSetUp];
}

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *favItems = [rootNode performSelector:@selector(favitems)];
    NSArray *groups = [rootNode performSelector:@selector(groups)];
    NSArray *childGroups = [groups[0] performSelector:@selector(groups)];
    
    NSURL *linkUrl = [favItems[0] performSelector:@selector(link)];
    XCTAssertTrue([linkUrl.absoluteString isEqualToString:@"www.webcontinuum.net"]);
    
    id desc = [childGroups[0] performSelector:@selector(elementDescription)];
    XCTAssertTrue([[desc performSelector:@selector(value)] isEqualToString:@"Group description"]);
    XCTAssertTrue([[groups[2] performSelector:@selector(name)] isEqualToString:@"Travel"]);
    
    favItems = [groups[2] performSelector:@selector(favitems)];
    
    linkUrl = [favItems[0] performSelector:@selector(link)];
    [linkUrl.absoluteString isEqualToString:@"www.britishairways.com"];
#pragma clang diagnostic pop
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
