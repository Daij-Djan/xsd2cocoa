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
    DDRunTask(@"/usr/bin/clang", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation", @"-lxml2", @"-I/usr/include/libxml2", @"-o", output, input, nil);
}

@end
