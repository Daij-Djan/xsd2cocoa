//
//  TRVSFormatter.h
//  ClangFormat
//
//  Created by Travis Jeffery on 1/9/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileFormatter.h"

@interface TRVSFormatter : NSObject<FileFormatter>

@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *executablePath;

+ (instancetype)sharedFormatter;
- (instancetype)initWithStyle:(NSString *)style
               executablePath:(NSString *)executablePath;

//returns the successfully formatted files
- (NSArray*)formatFiles:(NSArray*)files error:(NSError**)error;

- (BOOL)formatFile:(NSString*)file error:(NSError**)error;

@end
