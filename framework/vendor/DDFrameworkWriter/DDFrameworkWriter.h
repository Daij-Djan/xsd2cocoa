#import <Foundation/Foundation.h>

@interface DDFrameworkWriter : NSObject

+ (instancetype)sharedWriter;

//writes a dynamic objC framework for OSX OR a static framework - depending on what is passed in to libraries
- (BOOL) writeFrameworkWithIdentifier:(NSString*)bundleIdentifier
                              andName:(NSString*)name
                               atPath:(NSString*)outputFolder
                            libraries:(NSArray*)libraries //either only statics, or only dynamics
                              headers:(NSArray*)headers
                        resourceFiles:(NSArray*)resourceFiles
                                error:(NSError**)error;

//writes a dynamic objC module for IOS
- (BOOL) writeModuleWithIdentifier:(NSString*)bundleIdentifier
                           andName:(NSString*)name
                            atPath:(NSString*)outputFolder
                         libraries:(NSArray*)libraries //only dynamic libraries
                           headers:(NSArray*)headers
                     resourceFiles:(NSArray*)resourceFiles
                             error:(NSError**)error;

//---

- (BOOL) createDynamicLibAt:(NSString*)compiledFile
                 inputFiles:(NSArray*)inputFiles
            additionalFlags:(NSArray*)additionalFlags //if nil, defaults to: @"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation" (-o and -install_path are also set)
                      error:(NSError**)error;

- (BOOL) createStaticLibAt:(NSString*)compiledFile
                 inputFiles:(NSArray*)inputFiles
            additionalFlags:(NSArray*)additionalFlags //if nil, defaults to: @"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-arch", @"x86_64", @"-framework", @"foundation" (-o is also set)
                      error:(NSError**)error;

@end
