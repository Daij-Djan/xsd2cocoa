//
//  DDRunTask.c
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/15/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//
#import "DDRunTask.h"

int __DDRunTaskExt(NSString *cwd, NSString **output, NSString *command, NSMutableArray *args) {
    NSString *result;
    int terminationStatus;
    
    //setup task and run it - reading its stdout
    @autoreleasepool {
        NSMutableData *readData = [[NSMutableData alloc] init];
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *fileHandle = [pipe fileHandleForReading];
        NSData *data = nil;
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:command];
        if(args.count) {
            [task setArguments:args];
        }
        if(cwd.length) {
            [task setCurrentDirectoryPath:cwd];
        }
        [task setStandardOutput: pipe];
        [readData setLength:0];

#if DEBUG
        if(cwd.length) {
            NSLog(@"working dir = %@", cwd);
            [task setCurrentDirectoryPath:cwd];
        }

        NSMutableString *cmd = [NSMutableString stringWithFormat:@"%@ ", command];
        for (id arg in args) {
            [cmd appendFormat:@"%@ ", arg];
        }
        NSLog(@"%@", cmd);
#endif
        
        [task launch];
        while ((task != nil) && ([task isRunning]))	{
            data = [fileHandle availableData];
            [readData appendData:data];
        }
        
        if(readData.length) {
            result = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        }
        terminationStatus = task.terminationStatus;
    }
    
    if(output) {
        *output = result;
    }
#if DEBUG
    else {
        NSLog(@"%@", result);
    }
#endif
    
    return terminationStatus;
}

NSMutableArray *__DDRunTaskArgs( va_list varargs ) {
    id arg = nil;
    NSMutableArray *args = [NSMutableArray array];
    [arg dataUsingEncoding:NSUTF8StringEncoding];
    while ((arg = va_arg(varargs,id))) {
        if([arg isKindOfClass:[NSArray class]])
        {
            for (id childArg in arg) {
                id argString = [childArg respondsToSelector:@selector(path)] ? [childArg path] : [childArg description];
                argString = [argString stringByExpandingTildeInPath];
                [args addObject:argString];
            }
        }
        else {
            id argString = [arg respondsToSelector:@selector(path)] ? [arg path] : [arg description];
            argString = [argString stringByExpandingTildeInPath];
            [args addObject:argString];
        }
    }
    return args;
}

#pragma mark -

NSString *DDRunTask(NSString *command, ...) {
    NSString *output;
    
    //var args to string array
    va_list varargs;
    va_start(varargs, command);
    NSMutableArray *args = __DDRunTaskArgs(varargs);
    va_end(varargs);
    
    int status = __DDRunTaskExt(nil, &output, command, args);
    
    return status==0?output:nil;
}

int DDRunTaskExt(NSString *cwd, NSString **output, NSString *command, ...) {
    //var args to string array
    va_list varargs;
    va_start(varargs, command);
    NSMutableArray *args = __DDRunTaskArgs(varargs);
    va_end(varargs);
    
    return __DDRunTaskExt(cwd, output, command, args);
}
