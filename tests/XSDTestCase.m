//
//  XSDTest.m
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import "XSDTestCase.h"
#import <Cocoa/Cocoa.h>
#import "XSDConverterCore.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import "NSObject+DDDump.h"

#define KEEP_AND_SHOW 0

@interface XSDTestCase ()

@property NSURL *schemaUrl;
@property NSURL *templateUrl;
@property NSURL *xmlFileUrl;

@end

@implementation XSDTestCase {
    void *_loadedLibHandle;
}

NSURL *_tmpFolderUrl;
+ (NSURL *)tmpFolderUrl {
    return _tmpFolderUrl;
}

+ (void)helpSetUp {
    NSURL *tmpFolderUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]]];
    assert(tmpFolderUrl);
    BOOL bCreated = [[NSFileManager defaultManager] createDirectoryAtURL:tmpFolderUrl withIntermediateDirectories:NO attributes:nil error:nil];
    assert(bCreated);
    _tmpFolderUrl = tmpFolderUrl;
}

- (void)helpSetUp {
    assert(self.schemaName);
    assert(self.xmlFileName);
    assert(self.expectedFiles);
    assert(self.rootClassName);
    assert(self.parseMethodName);
    
    NSURL *schemaUrl = [[NSBundle bundleForClass:self.class] URLForResource:self.schemaName withExtension:@"xsd"];
    NSURL *xmlFileUrl = [[NSBundle bundleForClass:self.class] URLForResource:self.xmlFileName withExtension:@"xml"];
    assert(schemaUrl);
    assert(xmlFileUrl);
    self.schemaUrl = schemaUrl;
    self.xmlFileUrl = xmlFileUrl;

    assert(self.templateUrl);
}

- (void)helpTearDown {
}

+ (void)helpTearDown {
    if(_tmpFolderUrl) {
#if KEEP_AND_SHOW
        [[NSWorkspace sharedWorkspace] openFile:_tmpFolderUrl.path];
#else
        BOOL bDeleted = [[NSFileManager defaultManager] removeItemAtURL:_tmpFolderUrl error:nil];
        assert(bDeleted);
#endif
        _tmpFolderUrl = nil;
    }
}

- (NSString*)compiledParserPath {
    if(_tmpFolderUrl) {
        id fileName = [NSString stringWithFormat:@"%@%@-parser.dylib", self.schemaName, self.prefixOverride ? self.prefixOverride : @""];
        NSString *compiledFile = [_tmpFolderUrl.path stringByAppendingPathComponent:fileName];
        return compiledFile;
    }
    else {
        return nil;
    }
}

#pragma mark correctness tests

- (void)assertSchema:(id)schema {
}

- (void)helpTestCorrectnessParsingSchema {
    __block XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride error:nil];
    XCTAssert(schema);
    
    [self assertSchema:schema];
}

//---

- (void)assertParsedXML:(id)rootNode {
    NSLog(@"%@", [rootNode performSelector:@selector(dictionary)]);
    assert(NO);
}

- (void)helpTestCorrectnessGeneratingParser {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    BOOL bWritten;
    NSError *genError;
    bWritten = [schema generateInto:_tmpFolderUrl
                           products:XSDschemaGeneratorOptionSourceCode
                              error:&genError];
    XCTAssert(bWritten);

    //fix folder name
    id folderName = @"Sources";
    id srcFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                      isDirectory:YES].path;
    folderName = [NSString stringWithFormat:@"%@%@-Sources", self.schemaName, self.prefixOverride ? self.prefixOverride : @""];
    id destFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                       isDirectory:YES].path;
    [[NSFileManager defaultManager] removeItemAtPath:destFolder error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:srcFolder toPath:destFolder error:nil];
    
    //get contents
    id src = [NSURL fileURLWithPath:destFolder];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:src
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:nil];

    //check if we have all we need
    NSMutableArray *needed = [self.expectedFiles mutableCopy];
    for (NSURL *url in files) {
        id name = url.lastPathComponent;
        XCTAssert([needed containsObject:name], @"needed doesn't conaint %@", name);
        [needed removeObject:name];
    }
    XCTAssert(needed.count == 0);
    
    //compile it
    id fileName = [NSString stringWithFormat:@"%@%@-parser.dylib", self.schemaName, self.prefixOverride ? self.prefixOverride : @""];
    NSString *compiledFile = [_tmpFolderUrl.path stringByAppendingPathComponent:fileName];
    XCTAssert(![[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);

    //do it
    [self compileParser:compiledFile from:files];
    XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);
    if([[NSFileManager defaultManager] fileExistsAtPath:compiledFile]) {
        //open dylib
        void* lib_handle = dlopen(compiledFile.UTF8String, RTLD_LOCAL);
        XCTAssert(lib_handle);//dl_error()
        _loadedLibHandle = lib_handle;
        
        //load the root class (required with runtime-loaded libraries).
        Class wlfg_class = objc_getClass(self.rootClassName.UTF8String);
        XCTAssert(wlfg_class);
        XCTAssert([wlfg_class respondsToSelector:NSSelectorFromString(self.parseMethodName)]);
        
        //parse it
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id root = [wlfg_class performSelector:NSSelectorFromString(self.parseMethodName) withObject:self.xmlFileUrl];
#pragma clang diagnostic pop
        XCTAssert(root);
        NSLog(@"%@", [root dump]);
        
        //check it
        XCTAssert([root respondsToSelector:@selector(dictionary)]);
        if([root respondsToSelector:@selector(dictionary)]) {
            [self assertParsedXML:root];
        }
        
        //unload it
        root = nil;
        int status = dlclose(lib_handle);
        XCTAssert(status == 0);
        _loadedLibHandle = nil;
    }
}

- (void*)loadedLibHandle {
    return _loadedLibHandle;
}

#pragma mark performance tests

- (void)helpTestPerformanceParsingSchema {
    __block XSDschema *schema;
    [self measureBlock:^{
        schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride error:nil];
    }];
    XCTAssert(schema);
}

- (void)helpTestPerformanceLoadingTemplate {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride  error:nil];
    XCTAssert(schema);
    
    __block BOOL bLoaded;
    [self measureBlock:^{
        NSError *loadError;
        bLoaded = [schema loadTemplate:self.templateUrl error:&loadError];
    }];
    XCTAssert(bLoaded);
}

- (void)helpTestPerformanceGeneratingParser {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride  error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    __block BOOL bWritten;
    [self measureBlock:^{
        NSError *genError;
        
        bWritten = [schema generateInto:_tmpFolderUrl
                               products:XSDschemaGeneratorOptionSourceCode
                                  error:&genError];

        //fix folder name
        id folderName = @"Sources";
        id srcFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                      isDirectory:YES].path;
        folderName = [NSString stringWithFormat:@"%@%@-Sources", self.schemaName, self.prefixOverride ? self.prefixOverride : @""];
        id destFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                       isDirectory:YES].path;
        [[NSFileManager defaultManager] removeItemAtPath:destFolder error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:srcFolder toPath:destFolder error:nil];
    }];
    XCTAssert(bWritten);
}

- (void)helpTestPerformanceParsingXML {
    XSDschema *schema = [[XSDschema alloc] initWithUrl:self.schemaUrl targetNamespacePrefix:self.prefixOverride error:nil];
    XCTAssert(schema);
    
    NSError *error;
    BOOL bLoaded = [schema loadTemplate:self.templateUrl error:&error];
    XCTAssert(bLoaded);
    
    BOOL bWritten;
    bWritten = [schema generateInto:_tmpFolderUrl
                           products:XSDschemaGeneratorOptionSourceCode
                              error:&error];
    //fix folder name
    id folderName = @"Sources";
    id srcFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                  isDirectory:YES].path;
    folderName = [NSString stringWithFormat:@"%@%@-Sources", self.schemaName, self.prefixOverride ? self.prefixOverride : @""];
    id destFolder = [_tmpFolderUrl URLByAppendingPathComponent:folderName
                                                   isDirectory:YES].path;
    [[NSFileManager defaultManager] removeItemAtPath:destFolder error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:srcFolder toPath:destFolder error:nil];

    XCTAssert(bWritten);
    
    id src = [NSURL fileURLWithPath:destFolder];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:src
                                                   includingPropertiesForKeys:nil
                                                                      options:0
                                                                        error:nil];
    
    NSString *compiledFile = [_tmpFolderUrl.path stringByAppendingPathComponent:@"parser.dylib"];
    XCTAssert(![[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);

    //do it
    [self compileParser:compiledFile from:files];
    XCTAssert([[NSFileManager defaultManager] fileExistsAtPath:compiledFile]);
    
    void* lib_handle = dlopen(compiledFile.UTF8String, RTLD_LOCAL);
    XCTAssert(lib_handle);//dl_error()
    _loadedLibHandle = lib_handle;
    
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
    _loadedLibHandle = nil;
}

- (void)compileParser:(NSString *)output from:(NSArray *)input {
    assert(NO);
}

@end
