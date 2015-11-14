//
//  main.m
//  test
//
//  Created by Dominik Pich on 14/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "demoLocaleChoose.h"

void myGenericErrorFunc(id null, const char *msg, ...);
void myGenericErrorFunc(id null, const char *msg, ...)
{
	va_list vargs;
	va_start(vargs, msg);
	
	NSString *format = [NSString stringWithUTF8String:msg];
	NSMutableString *str = [[NSMutableString alloc] initWithFormat:format arguments:vargs];
	
	NSLog(@"%@", str);
	
	va_end(vargs);
}

int main(int argc, const char * argv[])
{
    if(argc<2) {
        NSLog(@"No xsdtest.xml files specified");
        return -1;
    }
    
	xmlSetGenericErrorFunc(NULL, (xmlGenericErrorFunc)myGenericErrorFunc);
    
    for (int i = 1; i<argc; i++) {
        @autoreleasepool {
            NSString *path = @(argv[i]);
            DEMOAvailableConfigs *fg = [DEMOAvailableConfigs availableConfigsFromFile:path];
            if(fg)
                NSLog(@"%@", fg.dictionary);
            else
                NSLog(@"failed to parse");
        }
    }
    return 0;
}

