//
//  ViewController.m
//  weblinks-ios
//
//  Created by Dominik Pich on 04/01/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import "ViewController.h"
#import <weblinks/weblinks.h>

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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextView *textView = self.view.subviews[0];
    
    @autoreleasepool {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"weblinks" ofType:@"xml"];
        WLFG *fg = [WLFG FGFromFile:path];
        if(fg)
            textView.text = fg.dictionary;
    }
}

@end
