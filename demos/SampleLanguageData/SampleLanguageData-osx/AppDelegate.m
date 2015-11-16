//
//  AppDelegate.m
//  weblinks-osx
//
//  Created by Dominik Pich on 05/01/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleLanguageData.h"
#import <libxml/xmlreader.h>

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

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSScrollView *scrollView = [self.window.contentView subviews][0];
    NSTextView *textView = scrollView.documentView;
    
    @autoreleasepool {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SampleLanguageData" ofType:@"xml"];
        LangDefType *fg = [LangDefType LangDefTypeFromFile:path];
        if(fg)
            textView.string = fg.dictionary.description;
    }
}

@end
