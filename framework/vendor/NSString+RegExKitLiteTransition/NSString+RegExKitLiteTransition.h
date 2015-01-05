//
//  NSString+RegExKitLiteTransition.h
//  HootSuite
//
//  Created by Gary Morrison on 2012-10-16.
//  Copyright (c) 2012 HootSuite Media Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

@interface NSString (RegExKitLiteTransition)

- (NSArray *) arrayOfCaptureComponentsMatchedByRegex:(NSString *)regex;
+ (NSArray *) arrayOfCaptureComponentsOfString:(NSString *)data matchedByRegex:(NSString *)regex;
- (NSRange)rangeOfRegex:(NSString *)regex options:(uint32_t)options inRange:(NSRange)range capture:(NSInteger)capture error:(NSError **)returnError;
@end
