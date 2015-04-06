//
//  XSDTest.m
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import "XSDTestCaseSwift.h"
#import <Cocoa/Cocoa.h>
#import "XSDConverterCore.h"
#import "DDRunTask.h"
#import <objc/runtime.h>
#import <dlfcn.h>

#define KEEP_AND_SHOW 1

@interface XSDTestCaseSwift ()

@property NSURL *schemaUrl;
@property NSURL *templateUrl;
@property NSURL *xmlFileUrl;
@property NSURL *tmpFolderUrl;

@end

@implementation XSDTestCaseSwift

- (void)helpSetUp {
    assert(self.schemaName);
    assert(self.xmlFileName);
    assert(self.expectedFiles);
    assert(self.rootClassName);
    assert(self.parseMethodName);
    
    NSURL *schemaUrl = [[NSBundle bundleForClass:self.class] URLForResource:self.schemaName withExtension:@"xsd"];
    NSURL *templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-swift" withExtension:@"xml"];
    NSURL *tmpFolderUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    NSURL *xmlFileUrl = [[NSBundle bundleForClass:self.class] URLForResource:self.xmlFileName withExtension:@"xml"];
    
    assert(schemaUrl);
    assert(templateUrl);
    assert(tmpFolderUrl);
    assert(xmlFileUrl);
    
    BOOL bCreated = [[NSFileManager defaultManager] createDirectoryAtURL:tmpFolderUrl withIntermediateDirectories:NO attributes:nil error:nil];
    assert(bCreated);
    
    self.schemaUrl = schemaUrl;
    self.templateUrl = templateUrl;
    self.tmpFolderUrl = tmpFolderUrl;
    self.xmlFileUrl = xmlFileUrl;
}

- (void)helpTearDown {
    if(self.tmpFolderUrl) {
#if KEEP_AND_SHOW
        [[NSWorkspace sharedWorkspace] openFile:self.tmpFolderUrl.path];
#else
        BOOL bDeleted = [[NSFileManager defaultManager] removeItemAtURL:self.tmpFolderUrl error:nil];
        assert(bDeleted);
#endif
    }
}

#pragma mark correctness tests

- (void)assertSchema:(id)schema {
}

- (void)helpTestCorrectnessParsingSchema {
    __block XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XCTAssert(schema);
    
    [self assertSchema:schema];
}

//---

- (void)assertParsedXML:(id)rootNode {
    NSLog(@"%@", [rootNode performSelector:@selector(dictionary)]);
}

- (void)helpTestCorrectnessGeneratingParserSwift {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    BOOL bWritten;
    NSError *genError;
    bWritten = [schema generateInto:self.tmpFolderUrl
                           products:XSDschemaGeneratorOptionSourceCode
                              error:&genError];
    XCTAssert(bWritten);
    
    id src = [self.tmpFolderUrl URLByAppendingPathComponent:@"Sources" isDirectory:YES];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:src
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:nil];
    NSArray *headerFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".h\""]];
    NSArray *swiftFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".swift\""]];
    
    //make module
    NSString *compiledFile = [self.tmpFolderUrl.path stringByAppendingPathComponent:@"libparser.dylib"];
    NSString *toolPath = DDRunTask(@"/usr/bin/xcrun", @"-f", @"--sdk", @"macosx", @"swiftc", nil);
    NSString *sdkPath = DDRunTask(@"/usr/bin/xcrun", @"--show-sdk-path", @"--sdk", @"macosx", nil);
    toolPath = [toolPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sdkPath = [sdkPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    XCTAssert(![[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);
    DDRunTaskExt(self.tmpFolderUrl.path, nil, toolPath, @"-target-cpu", @"x86-64", @"-module-name", @"parser", @"-O", @"-sdk", sdkPath, @"-import-objc-header", headerFiles.firstObject, @"-I/usr/include/libxml2", @"-lxml2", @"-emit-library", swiftFiles, nil);
    XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);

    void* lib_handle = dlopen(compiledFile.UTF8String, RTLD_LOCAL);
    XCTAssert(lib_handle);//dl_error()
    
    // Get the Person class (required with runtime-loaded libraries).
    Class wlfg_class = objc_getClass(self.rootClassName.UTF8String);
    XCTAssert(wlfg_class);
    XCTAssert([wlfg_class respondsToSelector:NSSelectorFromString(self.parseMethodName)]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id root = [wlfg_class performSelector:NSSelectorFromString(self.parseMethodName) withObject:self.xmlFileUrl];
#pragma clang diagnostic pop
    XCTAssert(root);
    XCTAssert([root respondsToSelector:@selector(dictionary)]);
    
    [self assertParsedXML:root];
    
    root = nil;
    int status = dlclose(lib_handle);
    XCTAssert(status == 0);
}

#pragma mark performance tests

- (void)helpTestPerformanceParsingSchema {
    __block XSDschema *schema;
    [self measureBlock:^{
        schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    }];
    XCTAssert(schema);
}

- (void)helpTestPerformanceLoadingTemplateSwift {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XCTAssert(schema);
    
    __block BOOL bLoaded;
    [self measureBlock:^{
        NSError *loadError;
        bLoaded = [schema loadTemplate:self.templateUrl error:&loadError];
    }];
    XCTAssert(bLoaded);
}

- (void)helpTestPerformanceGeneratingParserSwift {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    __block BOOL bWritten;
    [self measureBlock:^{
        NSError *genError;
        bWritten = [schema generateInto:self.tmpFolderUrl
                               products:XSDschemaGeneratorOptionSourceCode
                                  error:&genError];
    }];
    XCTAssert(bWritten);
}

- (void)helpTestPerformanceParsingXMLSwift {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:nil error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    BOOL bWritten;
    bWritten = [schema generateInto:self.tmpFolderUrl
                           products:XSDschemaGeneratorOptionSourceCode
                              error:&error];
    XCTAssert(bWritten);
    
    id src = [self.tmpFolderUrl URLByAppendingPathComponent:@"Sources" isDirectory:YES];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:src
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:nil];
    NSArray *headerFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".h\""]];
    NSArray *swiftFiles = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".swift\""]];
    
    //make module
    NSString *compiledFile = [self.tmpFolderUrl.path stringByAppendingPathComponent:@"libparser.dylib"];
    NSString *toolPath = DDRunTask(@"/usr/bin/xcrun", @"-f", @"--sdk", @"macosx", @"swiftc", nil);
    NSString *sdkPath = DDRunTask(@"/usr/bin/xcrun", @"--show-sdk-path", @"--sdk", @"macosx", nil);
    toolPath = [toolPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sdkPath = [sdkPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    XCTAssert(![[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);
    DDRunTaskExt(self.tmpFolderUrl.path, nil, toolPath, @"-target-cpu", @"x86-64", @"-module-name", @"parser", @"-O", @"-sdk", sdkPath, @"-import-objc-header", headerFiles.firstObject, @"-I/usr/include/libxml2", @"-lxml2", @"-emit-library", swiftFiles, nil);
    XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);
    
    void* lib_handle = dlopen(compiledFile.UTF8String, RTLD_LOCAL);
    XCTAssert(lib_handle);//dl_error()
    
    // Get the Person class (required with runtime-loaded libraries).
    Class wlfg_class = objc_getClass(self.rootClassName.UTF8String);
    XCTAssert(wlfg_class);
    XCTAssert([wlfg_class respondsToSelector:NSSelectorFromString(self.parseMethodName)]);

    __block id root;
    [self measureBlock:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        root = [wlfg_class performSelector:NSSelectorFromString(self.parseMethodName) withObject:self.xmlFileUrl];
#pragma clang diagnostic pop
    }];
    XCTAssert(root);
    XCTAssert([root respondsToSelector:@selector(dictionary)]);
    
    root = nil;
    int status = dlclose(lib_handle);
    XCTAssert(status == 0);
}

@end
