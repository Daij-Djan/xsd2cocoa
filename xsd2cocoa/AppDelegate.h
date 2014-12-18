//
//  AppDelegate.h
//  xsd2cocoa
//
//  Created by Dominik Pich on 11/12/13.
//
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *writeButton;

@property (weak) IBOutlet NSTextField *xsdFilePathTextfield;
@property (weak) IBOutlet NSTextField *outputFolderPathTextfield;
@property (weak) IBOutlet NSTextField *templatePathTextfield;
@property (weak) IBOutlet NSBox *advancedOptionsBox;

@property (weak) IBOutlet NSMatrix *templateStyleMatrix;
//@property (weak) IBOutlet NSTextField *additionalTypes;
@property (weak) IBOutlet NSTextField *customPrefix;

@property (weak) IBOutlet NSButton *writeHeaderCheckbox;

- (IBAction)openDocument:(id)sender;
- (IBAction)templateChosen:(id)sender;
- (IBAction)textfieldEdited:(id)sender;
- (IBAction)writeObjcCode:(id)sender;

- (IBAction)showXSDHelp:(id)sender;
//- (IBAction)showAdditionalTypesHelp:(id)sender;
- (IBAction)showCustomTemplateHelp:(id)sender;
- (IBAction)showPrefixHelp:(id)sender;

@end
