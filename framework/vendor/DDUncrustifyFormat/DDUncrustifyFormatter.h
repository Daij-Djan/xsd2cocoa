//
//  DDUncrustifyFormatter.h
//  Created by Dominik Pich on 2/2/15.
//

#import <Cocoa/Cocoa.h>
#import "FileFormatter.h"

@interface DDUncrustifyFormatter : NSObject<FileFormatter>

@property (nonatomic, copy) NSString *stylePath;
@property (nonatomic, copy) NSString *executablePath;

+ (instancetype)objectiveCFormatter;
+ (instancetype)swiftFormatter;

//---

- (instancetype)initWithStylePath:(NSString *)stylePath;
- (instancetype)initWithStylePath:(NSString *)stylePath
                   executablePath:(NSString *)executablePath;

- (NSArray*)formatFiles:(NSArray*)files error:(NSError**)error;
- (BOOL)formatFile:(NSString*)file error:(NSError**)error;

@end
