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
@property (weak) IBOutlet NSButton *advancedOptionsButton;
@property (strong) IBOutlet NSBox *advancedOptionsBox;

@property (weak) IBOutlet NSMatrix *templateStyleMatrix;
@property (weak) IBOutlet NSTextField *templatePathTextfield;
//@property (weak) IBOutlet NSTextField *additionalTypes;
@property (weak) IBOutlet NSTextField *customPrefix;

//@property (weak) IBOutlet NSButton *productTypeDynamicFramework;
//@property (weak) IBOutlet NSButton *productTypeStaticFramework;
@property (weak) IBOutlet NSButton *productTypeSourceCode;

- (IBAction)toggleAdvancedOptions:(id)sender;

- (IBAction)openDocument:(id)sender;
- (IBAction)templateChosen:(id)sender;
- (IBAction)textfieldEdited:(id)sender;
- (IBAction)writeCode:(id)sender;

- (IBAction)showXSDHelp:(id)sender;
//- (IBAction)showAdditionalTypesHelp:(id)sender;
- (IBAction)showCustomTemplateHelp:(id)sender;
- (IBAction)showPrefixHelp:(id)sender;

@end
