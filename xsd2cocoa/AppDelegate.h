//
//  AppDelegate.h
//  xsd2cocoa
//
//  Created by Dominik Pich on 11/12/13.
//
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *xsdFilePathTextfield;
@property (weak) IBOutlet NSTextField *outputFolderPathTextfield;
@property (weak) IBOutlet NSTextField *templatePathTextfield;
@property (weak) IBOutlet NSBox *advancedOptionsBox;

@property (weak) IBOutlet NSMatrix *templateStyleMatrix;
@property (weak) IBOutlet NSTextField *customPrefix;

- (IBAction)openDocument:(id)sender;
- (IBAction)writeObjcCode:(id)sender;

@end
