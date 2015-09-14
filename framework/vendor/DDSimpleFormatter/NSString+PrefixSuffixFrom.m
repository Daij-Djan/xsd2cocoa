//
//  String+PrefixSuffixFrom.swift
//  simpleFormatter
//
//  Created by Dominik Pich on 09/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//
#import "NSString+PrefixSuffixFrom.h"

@implementation NSString (PrefixSuffixFrom)

- (BOOL)hasPrefixFrom:(NSArray*)prefixes {
    for(id prefix in prefixes) {
        if([self hasPrefix:prefix]) {
            return true;
        }
    }
    return false;
}

- (BOOL)hasSuffixFrom:(NSArray*)suffixes {
    for(id suffix in suffixes) {
        if([self hasSuffix:suffix]) {
            return true;
        }
    }
    return false;
}

@end