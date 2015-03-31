//
//  XSDTest.h
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import <XCTest/XCTest.h>

@class XSDschema;

@interface XSDTestCaseSwift : XCTestCase

//set  all before inoking setUp
@property NSString *schemaName;
@property NSString *xmlFileName;
@property NSArray *expectedFiles;
@property NSString *rootClassName;
@property NSString *parseMethodName;

- (void)assertSchema:(XSDschema*)schema;
- (void)assertParsedXML:(id)rootNode;

//all help underway
- (void)helpSetUp;
- (void)helpTearDown;

#pragma mark correctness tests

- (void)helpTestCorrectnessParsingSchema;
- (void)helpTestCorrectnessGeneratingParserSwift;

#pragma mark performance tests

- (void)helpTestPerformanceParsingSchema;
- (void)helpTestPerformanceLoadingTemplateSwift;
- (void)helpTestPerformanceGeneratingParserSwift;
- (void)helpTestPerformanceParsingXMLSwift;
@end
