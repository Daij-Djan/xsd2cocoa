//
//  FileFormatter.h
//  XSDConverter
//
//  Created by Dominik Pich on 05/04/15.
//
//

#import <Foundation/Foundation.h>

@protocol FileFormatter <NSObject>

- (NSArray*)formatFiles:(NSArray*)files error:(NSError**)error;
- (BOOL)formatFile:(NSString*)file error:(NSError**)error;

@end
