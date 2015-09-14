//
//  XSDTest.h
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import <XCTest/XCTest.h>

@class XSDschema;

@interface XSDTestCase : XCTestCase

//set  all before inoking setUp
@property NSString *schemaName;
@property NSString *xmlFileName;
@property NSArray *expectedFiles;
@property NSString *rootClassName;
@property NSString *parseMethodName;

@property (readonly) NSURL *schemaUrl;
@property (readonly) NSURL *templateUrl;
@property (readonly) NSURL *xmlFileUrl;
+ (NSURL*)tmpFolderUrl;

//optional
@property NSString *prefixOverride;

- (void)assertSchema:(XSDschema*)schema;
- (void)assertParsedXML:(id)rootNode;

//all help underway
+ (void)helpSetUp;
- (void)helpSetUp;
- (void)helpTearDown;
+ (void)helpTearDown;

- (void)compileParser:(NSString*)output from:(NSArray*)input;
- (NSString*)compiledParserPath;

#pragma mark correctness tests

- (void)helpTestCorrectnessParsingSchema;
- (void)helpTestCorrectnessGeneratingParser;

#pragma mark performance tests

- (void)helpTestPerformanceParsingSchema;
- (void)helpTestPerformanceLoadingTemplate;
- (void)helpTestPerformanceGeneratingParser;
- (void)helpTestPerformanceParsingXML;
@end
