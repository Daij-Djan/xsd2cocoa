//
//  SimpleFormatter.swift
//  simpleFormatter
//
//  Created by Dominik Pich on 10/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSimpleFormatter: NSObject

+ (instancetype)sharedInstance;

- (NSString*)formatString:(NSString*)string;

- (BOOL)formatFile:(NSString *)file error:(NSError *__autoreleasing *)error;
- (NSArray *)formatFiles:(NSArray *)files error:(NSError *__autoreleasing *)error;

@end