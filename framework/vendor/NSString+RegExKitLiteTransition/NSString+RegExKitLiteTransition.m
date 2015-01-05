//
//  NSString+RegExKitLiteTransition.m
//  HootSuite
//
//  Created by Gary Morrison on 2012-10-16.
//  Copyright (c) 2012 HootSuite Media Inc. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif

#import "NSString+RegExKitLiteTransition.h"

@implementation NSString (RegExKitLiteTransition)

- (NSArray *) arrayOfCaptureComponentsMatchedByRegex:(NSString *)regex {
    return [NSString arrayOfCaptureComponentsOfString:self matchedByRegex:regex];
}

+ (NSArray *) arrayOfCaptureComponentsOfString:(NSString *)data matchedByRegex:(NSString *)regex
{
    NSError *error = NULL;
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSMutableArray *test = [NSMutableArray array];
    
    NSArray *matches = [regExpression matchesInString:data options:(NSMatchingOptions)NSRegularExpressionSearch range:NSMakeRange(0, data.length)];
    
    for(NSTextCheckingResult *match in matches) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:match.numberOfRanges];
        for(NSInteger i=0; i<match.numberOfRanges; i++) {
            NSRange matchRange = [match rangeAtIndex:i];
            NSString *matchStr = nil;
            if(matchRange.location != NSNotFound) {
                matchStr = [data substringWithRange:matchRange];
            } else {
                matchStr = @"";
            }
            [result addObject:matchStr];
        }
        [test addObject:result];
    }
    return test;
}

- (NSRange)rangeOfRegex:(NSString *)regex options:(uint32_t)options inRange:(NSRange)range capture:(NSInteger)capture error:(NSError **)returnError {
    
    NSError *error = NULL;
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regExpression firstMatchInString:self options:(NSMatchingOptions)NSRegularExpressionSearch range:range];
    
    if (match && capture < match.numberOfRanges) {
        return [match rangeAtIndex:capture];
    }
    
    return NSMakeRange(NSNotFound,0);
}

@end
