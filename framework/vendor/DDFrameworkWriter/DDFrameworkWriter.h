#import <Foundation/Foundation.h>

@interface DDFrameworkWriter : NSObject

+ (instancetype)sharedWriter;

//writes a dynamic objC framework for OSX
- (BOOL) writeFrameworkWithIdentifier:(NSString*)bundleIdentifier
                              andName:(NSString*)name
                               atPath:(NSString*)outputFolder
                           inputFiles:(NSArray*)inputFiles
                        resourceFiles:(NSArray*)resourceFiles
                      additionalFlags:(NSArray*)additionalFlags //can be architectures, includes, frameworks or additional libs or ANYTHING else that can be passed to clang (can be nil! the default: @"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation")
                                error:(NSError**)error;

//NOT DONE
//writes a dynamic objC module for IOS
- (BOOL) writeModuleWithIdentifier:(NSString*)bundleIdentifier
                           andName:(NSString*)name
                            atPath:(NSString*)outputFolder
                        inputFiles:(NSArray*)inputFiles
                     resourceFiles:(NSArray*)resourceFiles
                      additionalFlags:(NSArray*)additionalFlags //can be architectures, includes, frameworks or additional libs or ANYTHING else that can be passed to clang (can be nil! the default: @"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"arm7", @"-framework", @"foundation")
                             error:(NSError**)error;

@end
