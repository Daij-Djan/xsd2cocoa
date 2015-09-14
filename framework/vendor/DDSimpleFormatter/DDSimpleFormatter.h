//
//  SimpleFormatter.swift
//  simpleFormatter
//
//  Created by Dominik Pich on 10/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileFormatter.h"

@interface DDSimpleFormatter: NSObject<FileFormatter>

+ (instancetype)sharedInstance;
- (NSString*)formatString:(NSString*)string;

@end