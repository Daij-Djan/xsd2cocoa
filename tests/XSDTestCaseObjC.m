//
//  XSDTest.m
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import "XSDTestCaseObjC.h"
#import "XSDschema.h"
#import "DDRunTask.h"

@interface XSDTestCase (private)
@property NSURL *templateUrl;
@end

@implementation XSDTestCaseObjC

- (void)helpSetUp {
    NSURL *templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-objc" withExtension:@"xml"];
    assert(templateUrl);
    self.templateUrl = templateUrl;
    
    [super helpSetUp];
}

- (void)compileParser:(NSString *)output from:(NSArray *)input {
    id tmp = [self.class tmpFolderUrl].path;

    //get sdk paths
    NSString *toolPath = DDRunTask(@"/usr/bin/xcrun", @"-f", @"--sdk", @"macosx", @"clang", nil);
    NSString *sdkPath = DDRunTask(@"/usr/bin/xcrun", @"--show-sdk-path", @"--sdk", @"macosx", nil);
    toolPath = [toolPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sdkPath = [sdkPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    id env = @{@"SDKROOT": sdkPath};
    
    DDRunTaskExt(tmp, env, nil, toolPath, @"-isysroot", [NSString stringWithFormat:@"%@", sdkPath], @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation", @"-lxml2", [NSString stringWithFormat:@"-I%@/usr/include/libxml2", sdkPath], @"-o", output, input, nil);
}

@end
