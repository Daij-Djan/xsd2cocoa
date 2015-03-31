#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "DDFrameworkWriter.h"
#import "DDRunTask.h"

@implementation DDFrameworkWriter

+ (instancetype)sharedWriter {
    static id _sharedWriter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWriter = [[[self class] alloc] init];
    });
    return _sharedWriter;
}

#pragma mark - create framework

- (BOOL) writeFrameworkWithIdentifier:(NSString*)bundleIdentifier
                              andName:(NSString*)name
                               atPath:(NSString*)outputFolder
                            libraries:(NSArray*)libraries
                              headers:(NSArray*)headerFiles
                        resourceFiles:(NSArray*)resourceFiles
                                error:(NSError**)error {
    //make the path of the framework
    if([name hasSuffix:@".framework"]) {
        name = [name stringByDeletingPathExtension];
    }
    NSString *frameworkFolder = [[outputFolder stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"framework"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //check for existing folder
    if([fm fileExistsAtPath:frameworkFolder]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"framework folder already exists"}];
        return NO;
    }
    
    //create the structure now
    id versionsFolder = [frameworkFolder stringByAppendingPathComponent:@"Versions"];
    id aFolder = [versionsFolder stringByAppendingPathComponent:@"A"];
    if(![fm createDirectoryAtPath:aFolder withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }

    //copy compiled & merge
//    id compiledFile = [aFolder stringByAppendingPathComponent:name];
//    id installPath = [NSString stringWithFormat:@"@rpath/%@.framework/%@", name, name];
//    if(![self createOSXLibAt:compiledFile
//                 installPath:installPath
//                  inputFiles:inputFiles
//             additionalFlags:additionalFlags
//                       error:error]) {
//        [fm removeItemAtPath:frameworkFolder error:nil];
//        return NO;
//    }
    
    //link it
    id link = [frameworkFolder stringByAppendingPathComponent:name];
    if(![fm createSymbolicLinkAtPath:link
                 withDestinationPath:[NSString stringWithFormat:@"./Versions/A/%@", name]
                               error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }

    //copy resources
    id resourcesFolder= [aFolder stringByAppendingPathComponent:@"Resources"];
    if(![self createFolder:resourcesFolder withFiles:resourceFiles error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }

    //link it
    link = [frameworkFolder stringByAppendingPathComponent:@"Resources"];
    if(![fm createSymbolicLinkAtPath:link
                 withDestinationPath:@"./Versions/A/Resources"
                               error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }

    //copy the headers
    id headerFolder= [aFolder stringByAppendingPathComponent:@"Headers"];
    if(headerFiles.count) {
        if(![self createFolder:headerFolder withFiles:headerFiles error:error]) {
            [fm removeItemAtPath:frameworkFolder error:nil];
            return NO;
        }
        //link it
        link = [frameworkFolder stringByAppendingPathComponent:@"Headers"];
        if(![fm createSymbolicLinkAtPath:link
                     withDestinationPath:@"./Versions/A/Headers"
                                   error:error]) {
            [fm removeItemAtPath:frameworkFolder error:nil];
            return NO;
        }
    }

    //plist
    id plistFile = [resourcesFolder stringByAppendingPathComponent:@"Info.plist"];
    if(![self createInfoPlistAt:plistFile withIdentifier:bundleIdentifier andName:name error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }
    
    return YES;
}

//writes a dynamic objC module for IOS
- (BOOL) writeModuleWithIdentifier:(NSString*)bundleIdentifier
                           andName:(NSString*)name
                            atPath:(NSString*)outputFolder
                         libraries:(NSArray*)libraries
                           headers:(NSArray*)headerFiles
                     resourceFiles:(NSArray*)resourceFiles
                             error:(NSError**)error {
    //make the path of the framework
    if([name hasSuffix:@".framework"]) {
        name = [name stringByDeletingPathExtension];
    }
    NSString *frameworkFolder = [[outputFolder stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"framework"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //check for existing folder
    if([fm fileExistsAtPath:frameworkFolder]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"framework folder already exists"}];
        return NO;
    }
    
    //create the structure now
    id modulesFolder = [frameworkFolder stringByAppendingPathComponent:@"Modules"];
    if(![fm createDirectoryAtPath:modulesFolder withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }

    //copy compiled & merge
//    id compiledFile = [frameworkFolder stringByAppendingPathComponent:name];
//    id installPath = [NSString stringWithFormat:@"@rpath/%@.framework/%@", name, name];
//    if(![self createOSXLibAt:compiledFile
//                 installPath:installPath
//                  inputFiles:inputFiles
//             additionalFlags:additionalFlags
//                       error:error]) {
//        [fm removeItemAtPath:frameworkFolder error:nil];
//        return NO;
//    }
    
    //copy resources
    if(![self createFolder:frameworkFolder withFiles:resourceFiles error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }
    
    //copy the headers
    id headerFolder= [frameworkFolder stringByAppendingPathComponent:@"Headers"];
    if(headerFiles.count) {
        if(![self createFolder:headerFolder withFiles:headerFiles error:error]) {
            [fm removeItemAtPath:frameworkFolder error:nil];
            return NO;
        }
    }
    
    //plist & mmap
    id plistFile = [frameworkFolder stringByAppendingPathComponent:@"Info.plist"];
    if(![self createInfoPlistAt:plistFile withIdentifier:bundleIdentifier andName:name error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }
    id modulesFile = [modulesFolder stringByAppendingPathComponent:@"module.modulemap"];
    if(![self createModuleMapAt:modulesFile withName:name error:error]) {
        [fm removeItemAtPath:frameworkFolder error:nil];
        return NO;
    }

    return YES;
}

#pragma mark framework helpers

-(BOOL)createFolder:(NSString*)folder withFiles:(NSArray*)files error:(NSError**)error {
    NSFileManager *fm = [NSFileManager defaultManager];

    //create folder
    if(![fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:error]) {
        BOOL isDir;
        if(![fm fileExistsAtPath:folder isDirectory:&isDir] || !isDir) {
            return NO;
        }
    }
    
    //copy
    for (NSString *path in files) {
        id dest = [folder stringByAppendingPathComponent:path.lastPathComponent];
        if(![fm copyItemAtPath:path toPath:dest error:error]) {
            return NO;
        }
    }
    
    return YES;
}

-  (BOOL)createInfoPlistAt:(NSString*)path
            withIdentifier:(NSString*)bundleIdentifier
                   andName:(NSString*)name
                     error:(NSError**)error {
    NSDictionary *plist = @{@"CFBundleDevelopmentRegion": @"en",
                            @"CFBundleExecutable": name,
                            @"CFBundleIdentifier": bundleIdentifier,
                            @"CFBundleInfoDictionaryVersion": @"6.0",
                            @"CFBundleName": name,
                            @"CFBundlePackageType": @"FMWK",
                            @"CFBundleShortVersionString": @"1.0",
                            @"CFBundleSignature": @"????",
                            @"CFBundleVersion": @"1" };
    return [plist writeToFile:path atomically:YES];
}

-  (BOOL)createModuleMapAt:(NSString*)path
                   withName:(NSString*)name
                     error:(NSError**)error {
    NSString *map = [NSString stringWithFormat:@"\
framework module %@ {\
    umbrella header \"%@.h\"\
\
    export *\
    module * { export * }\
}", name, name];
    
    return [map writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
}

#pragma mark - compile libs

- (BOOL) createDynamicLibAt:(NSString*)compiledFile
                 inputFiles:(NSArray*)inputFiles
            additionalFlags:(NSArray*)additionalFlags
                      error:(NSError**)error {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //make sure there arent -o flags already
    if([additionalFlags containsObject:@"-o"]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"Dont specify the output filename for clang as that is set by the writer itself"}];
        return NO;
    }
    
    //install_name flags are ours
    if([additionalFlags containsObject:@"-install_name"]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"Dont specify the install_name flag for clang as that is set by the writer itself"}];
        return NO;
    }
    
    //default
    if(!additionalFlags.count) {
        additionalFlags = @[@"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-dynamiclib", @"-arch", @"x86_64", @"-framework", @"foundation"];
    }
    
    //call it
    DDRunTask(@"/usr/bin/clang", additionalFlags, @"-o", compiledFile, inputFiles, nil);
    
    if(![fm fileExistsAtPath:compiledFile]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"failed to compile the input files"}];
        return NO;
    }
    
    return YES;
}

- (BOOL) createStaticLibAt:(NSString*)compiledFile
                inputFiles:(NSArray*)inputFiles
           additionalFlags:(NSArray*)additionalFlags
                     error:(NSError**)error {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //make sure there arent -o flags already
    if([additionalFlags containsObject:@"-o"]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"Dont specify the output filename for clang as that is set by the writer itself"}];
        return NO;
    }
    
    //default
    if(!additionalFlags.count) {
        additionalFlags = @[@"-dead_strip", @"-fobjc-arc", @"-ObjC", @"-arch", @"x86_64", @"-framework", @"foundation"];
    }
    
    //call it
    DDRunTask(@"/usr/bin/clang", additionalFlags, @"-o", compiledFile, inputFiles, nil);
    
    if(![fm fileExistsAtPath:compiledFile]) {
        if(error)
            *error = [NSError errorWithDomain:@"DDFrameworkWriter" code:1 userInfo:@{NSLocalizedRecoverySuggestionErrorKey: @"failed to compile the input files"}];
        return NO;
    }
    
    return YES;
}

@end
