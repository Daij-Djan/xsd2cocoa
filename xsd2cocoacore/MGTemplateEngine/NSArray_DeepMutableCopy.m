//
//  NSArray_DeepMutableCopy.m
//
//  Created by Matt Gemmell on 02/05/2008.
//  Copyright 2008 Instinctive Code. All rights reserved.
//

#import "NSArray_DeepMutableCopy.h"


@implementation NSArray (DeepMutableCopy)


- (NSMutableArray *)deepMutableCopy;
{
    NSMutableArray *newArray;
    unsigned int index, count;
	
    count = (int) [self count];
    newArray = [[NSMutableArray allocWithZone:nil] initWithCapacity:count];
    for (index = 0; index < count; index++) {
        id anObject;
		
        anObject = [self objectAtIndex:index];
        if ([anObject respondsToSelector:@selector(deepMutableCopy)]) {
            anObject = [anObject deepMutableCopy];
            [newArray addObject:anObject];
        } else if ([anObject respondsToSelector:@selector(mutableCopyWithZone:)]) {
            anObject = [anObject mutableCopyWithZone:nil];
            [newArray addObject:anObject];
        } else {
            [newArray addObject:anObject];
        }
    }
	
    return newArray;
}


@end
