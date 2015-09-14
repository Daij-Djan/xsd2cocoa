//
//  SimpleFormatter.swift
//  simpleFormatter
//
//  Created by Dominik Pich on 10/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//
#import "DDSimpleFormatter.h"
#import "NSString+PrefixSuffixFrom.h"

#define stringsToIndent @[@"{"]
#define stringsToOutdent @[@"}"]
#define stringsToIgnore @[@"{{", @"}}", @"{%", @"%}"]
#define stringForIndentation @"    "

@implementation DDSimpleFormatter

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSString *)formatString:(NSString *)string {
    id set = [NSCharacterSet newlineCharacterSet];
    id set2 = [NSCharacterSet whitespaceCharacterSet];

    //get lines
    id lines = [string componentsSeparatedByCharactersInSet:set];
        
    //do indentation run
    NSMutableString *newLines = [NSMutableString string];
    int indent = 0;
    BOOL lastLineWasEmpty = false;
    for(id line in lines) {
        //first we trim it
        id trimmed = [line stringByTrimmingCharactersInSet:set2];
        //skip double blanks
        if(![trimmed length]) {
            if(lastLineWasEmpty) {
                continue;
            }
            lastLineWasEmpty = true;
        }
        else {
            lastLineWasEmpty = false;
        }
        
        //we check if we OUTDENT
        if([trimmed hasPrefixFrom:stringsToOutdent]) {
            if(![trimmed hasSuffixFrom:stringsToIgnore]) {
                indent--;
                if(indent < 0) {
                    indent = 0;
                }
            }
        }
        
        //assemble line
        for(int i=0; i<indent; i++) {
            [newLines appendString:stringForIndentation];
        }
        [newLines appendString:trimmed];
        [newLines appendString:@"\n"];
        
        //check if we end with indetation
        if([trimmed hasSuffixFrom:stringsToIndent]) {
            if(stringsToIgnore != nil) {
                if(![trimmed hasSuffixFrom:stringsToIgnore]) {
                    indent++;
                }
            }
        }
    }
    
    return newLines;
}

#pragma formatter

- (BOOL)formatFile:(NSString *)file error:(NSError *__autoreleasing *)error {
    if(!file)
        return false;
    
    //read it
    NSStringEncoding enc;
    id str = [NSString stringWithContentsOfFile:file usedEncoding:&enc error:error];
    if(!str)
        return false;
    
    //format it
    id formatted = [self formatString:str];
    if(!formatted)
        return false;
    
    //write it
    BOOL br = [formatted writeToFile:file atomically:YES encoding:enc error:error];
    
    return br;
}
- (NSArray *)formatFiles:(NSArray *)files error:(NSError *__autoreleasing *)error {
    NSMutableArray *arr = [NSMutableArray array];
    for (id file in files) {
        BOOL br = [self formatFile:file error:error];
        if(!br) {
            break;
        }
        [arr addObject:file];
    }
    return arr;
}
@end
