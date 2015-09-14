//
//  String+PrefixSuffixFrom.swift
//  simpleFormatter
//
//  Created by Dominik Pich on 09/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (PrefixSuffixFrom)
- (BOOL)hasPrefixFrom:(NSArray*)prefixes;
- (BOOL)hasSuffixFrom:(NSArray*)suffixes;
@end