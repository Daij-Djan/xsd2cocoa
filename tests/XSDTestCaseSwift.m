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

@interface XSDTestCase (private)
@property NSURL *templateUrl;
@end

@implementation XSDTestCaseSwift

- (void)helpSetUp {
    NSURL *templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-swift" withExtension:@"xml"];
    assert(templateUrl);
    self.templateUrl = templateUrl;

    [super helpSetUp];
}

- (void)compileParser:(NSString *)output from:(NSArray *)input {
    id tmp = [self.class tmpFolderUrl].path;
    NSArray *headerFiles = [input filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".h\""]];
    NSArray *swiftFiles = [input filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent ENDSWITH \".swift\""]];
    
    //make module
    NSString *toolPath = DDRunTask(@"/usr/bin/xcrun", @"-f", @"--sdk", @"macosx", @"swiftc", nil);
    NSString *sdkPath = DDRunTask(@"/usr/bin/xcrun", @"--show-sdk-path", @"--sdk", @"macosx", nil);
    toolPath = [toolPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sdkPath = [sdkPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    DDRunTaskExt(tmp, nil, toolPath, @"-target-cpu", @"x86-64", @"-module-name", @"parser", @"-O", @"-sdk", sdkPath, @"-import-objc-header", headerFiles.firstObject, @"-I/usr/include/libxml2", @"-lxml2", @"-emit-library", @"-o", output, swiftFiles, nil);
}

@end
