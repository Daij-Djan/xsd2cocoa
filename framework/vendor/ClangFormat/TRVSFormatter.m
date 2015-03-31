//
//  TRVSFormatter.m
//  ClangFormat
//
//  Created by Travis Jeffery on 1/9/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSFormatter.h"
#import "DDRunTask.h"

@implementation TRVSFormatter

+ (instancetype)sharedFormatter {
  static id sharedFormatter = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      NSBundle *bundle = [NSBundle bundleForClass:self.class];
      NSString *executablePath = [bundle pathForResource:@"clang-format" ofType:nil];
      sharedFormatter = [[self alloc] initWithStyle:@"LLVM"
                                     executablePath:executablePath];
  });

  return sharedFormatter;
}

- (instancetype)initWithStyle:(NSString *)style
               executablePath:(NSString *)executablePath {
  if (self = [self init]) {
    self.style = style;
    self.executablePath = executablePath;
  }
  return self;
}

- (NSArray*)formatFiles:(NSArray *)files error:(NSError**)error {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *file in files) {
        BOOL br = [self formatFile:file error:error];
        
        if(br) {
            [array addObject:file];
        }
        else {
            break;
        }
    }
    
    return array;
}

- (BOOL)formatFile:(NSString*)file error:(NSError**)error {
    int ret = DDRunTaskExt(nil, nil, self.executablePath,
                           [NSString stringWithFormat:@"--style=%@", self.style],
                           @"-i",
                           file,
                           nil);
    
    if(ret != 0 && error) {
        *error = [NSError errorWithDomain:@"clangFormat" code:1 userInfo:nil];
    }
    
    return ret == 0;
}

@end
