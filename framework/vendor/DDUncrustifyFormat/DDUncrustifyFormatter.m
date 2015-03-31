//
//  DDUncrustifyFormatter.m
//  Created by Dominik Pich on 2/2/15.
//

#import "DDUncrustifyFormatter.h"
#import "DDRunTask.h"

@implementation DDUncrustifyFormatter

+ (instancetype)objectiveCFormatter {
  static id sharedFormatter = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      NSBundle *bundle = [NSBundle bundleForClass:self.class];
      NSString *stylePath = [bundle pathForResource:@"uncrustify_objc" ofType:@"cfg"];
      sharedFormatter = [[self alloc] initWithStylePath:stylePath];
  });

  return sharedFormatter;
}

+ (instancetype)swiftFormatter {
    static id sharedFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        NSString *stylePath = [bundle pathForResource:@"uncrustify_swift" ofType:@"cfg"];
        sharedFormatter = [[self alloc] initWithStylePath:stylePath];
    });
    
    return sharedFormatter;
}

#pragma mark -

- (instancetype)initWithStylePath:(NSString *)stylePath {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *executablePath = [bundle pathForResource:@"uncrustify" ofType:nil];
    return [self initWithStylePath:stylePath executablePath:executablePath];
}

- (instancetype)initWithStylePath:(NSString *)stylePath
                   executablePath:(NSString *)executablePath {
  if (self = [self init]) {
    self.stylePath = stylePath;
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
                           @"-c",
                           self.stylePath,
                           @"-f",
                           file,
                           nil);
    
    if(ret != 0 && error) {
        *error = [NSError errorWithDomain:@"clangFormat" code:1 userInfo:nil];
    }
    
    return ret == 0;
}

@end
