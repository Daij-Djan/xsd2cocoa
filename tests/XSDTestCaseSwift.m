//
//  XSDTest.m
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import "XSDTestCaseSwift.h"
#import "XSDschema.h"
#import "DDRunTask.h"
#import <objc/runtime.h>
#import "XSSimpleType.h"

@interface XSDTestCase (private)
@property NSURL *templateUrl;
@end

//make selector known
@interface NSObject (add)
+ (NSNumber*)getNSNumberForProperty:(id)obj name:(NSString*)propertyName;
@end

@implementation XSDTestCaseSwift

- (void)helpSetUp {
    gUnitTestingSwiftCode = YES;
    
    NSURL *templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-swift" withExtension:@"xml"];
    assert(templateUrl);
    self.templateUrl = templateUrl;

    [super helpSetUp];
}

- (void)compileParser:(NSString *)output from:(NSArray *)input {
    id tmp = [self.class tmpFolderUrl].path;
    NSArray *headerFiles = [input filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".h\""]];
    NSArray *swiftFiles = [input filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".swift\""]];

    NSURL *extraSwiftFileUrl = [[NSBundle bundleForClass:[XSDTestCaseSwift class]] URLForResource:@"DDReflectionHelpers" withExtension:@"template"];
    assert(extraSwiftFileUrl);
    
    NSURL *extraSwiftFileTargetUrl = [[self.class tmpFolderUrl] URLByAppendingPathComponent:@"ReflectionHelpers.swift"];
    [[NSFileManager defaultManager] copyItemAtURL:extraSwiftFileUrl toURL:extraSwiftFileTargetUrl error:nil];
    NSMutableArray *allFiles = [@[extraSwiftFileTargetUrl] mutableCopy];
    if(swiftFiles) {
        [allFiles addObjectsFromArray:swiftFiles];
    }
    
    //get sdk paths
    NSString *toolPath = DDRunTask(@"/usr/bin/xcrun", @"-f", @"--sdk", @"macosx", @"swiftc", nil);
    NSString *sdkPath = DDRunTask(@"/usr/bin/xcrun", @"--show-sdk-path", @"--sdk", @"macosx", nil);
    toolPath = [toolPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sdkPath = [sdkPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    id env = @{@"SDKROOT": sdkPath};

    DDRunTaskExt(tmp, env, nil, toolPath, @"-target-cpu", @"x86-64", @"-module-name", @"parser", @"-O", @"-sdk", sdkPath, @"-import-objc-header", headerFiles.firstObject, [NSString stringWithFormat:@"-I%@/usr/include/libxml2", sdkPath], @"-lxml2", @"-emit-library", @"-o", output, allFiles, nil);
}

- (NSNumber*)reflect:(id)obj numberForKey:(NSString*)propertyName {
//    NSLog(@"%@", [NSObject classDumps]);
    Class wlfg_class = objc_getClass("parser.ReflectionHelpers");
    XCTAssert(wlfg_class);
    
    id n = [wlfg_class getNSNumberForProperty:obj name:propertyName];
    
    return n;
}

@end
