//
//  AppDelegate.m
//  xsd2cocoa
//
//  Created by Dominik Pich on 11/12/13.
//
//

#import "AppDelegate.h"
#import <XSDConverterCore/XSDConverterCore.h>

@interface AppDelegate () <NSOpenSavePanelDelegate, NSApplicationDelegate>
@end

@implementation AppDelegate

- (IBAction)toggleAdvancedOptions:(id)sender {
    //toggle
    self.advancedOptionsBox.hidden = !self.advancedOptionsBox.isHidden;
    
    //adapt frame
    CGRect f = self.window.frame;
    if(!self.advancedOptionsBox.isHidden) {
        //show and move button
        f.size.height += self.advancedOptionsBox.frame.size.height;
        f.origin.y -= self.advancedOptionsBox.frame.size.height;
        
        //add box
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self.window contentView] addSubview:self.advancedOptionsBox];
            CGRect box = self.advancedOptionsBox.frame;
            box.origin = CGPointMake(20, 49);
            self.advancedOptionsBox.frame = box;
        });
    }
    else {
        ///hide and move button
        f.size.height -= self.advancedOptionsBox.frame.size.height;
        f.origin.y += self.advancedOptionsBox.frame.size.height;
        
        [self.advancedOptionsBox removeFromSuperview];
    }
    [self.window setFrame:f display:YES animate:YES];
}

- (IBAction)openDocument:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canCreateDirectories = YES;
    panel.canChooseFiles = YES;
    panel.allowsMultipleSelection = YES;
    panel.delegate = self;
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(result==NSFileHandlingPanelOKButton) {
            for (NSURL *url in panel.URLs) {
                if(!url.isFileURL) {
                    continue;
                }
                
                //see if it it's a directory or file
                NSNumber *value;
                [url getResourceValue:&value forKey:NSURLIsDirectoryKey error:NULL];
                if(value.boolValue) {
                    self.outputFolderPathTextfield.stringValue = url.path;
                }
                else {
                    //read the first XMLNode's name (if possible)
                    id name = [XMLUtils rootNodeNameFromURL:url];
                    if(name) {
                        if([name isEqualToString:@"schema"]) {
                            self.xsdFilePathTextfield.stringValue = url.path;
                            if(!self.outputFolderPathTextfield.stringValue.length) {
                                NSURL *folder = [url URLByDeletingLastPathComponent];
                                if([[NSFileManager defaultManager] isWritableFileAtPath:folder.path]) {
                                    self.outputFolderPathTextfield.stringValue = folder.path;
                                }
                            }
                        }
                        else if([name isEqualToString:@"template"]) {
                            self.templatePathTextfield.stringValue = url.path;
                            [self.templateStyleMatrix selectCellWithTag:3];
                            
                            if(self.advancedOptionsButton.state == NSOffState) {
                                self.advancedOptionsButton.state = NSOnState;
                                [self toggleAdvancedOptions:nil];
                            }
                        }
                    }
                }
                
                [self validateWriteButton];
            }
        }
    }];
}

- (IBAction)templateChosen:(id)sender {
    [self validateWriteButton];
}

- (IBAction)textfieldEdited:(id)sender {
    [self validateWriteButton];
}

- (IBAction)writeCode:(id)sender {
    NSFileManager* fm = [NSFileManager defaultManager];
    
    //get dir if specified
    NSMutableDictionary* options = [NSMutableDictionary dictionary];
    if(self.outputFolderPathTextfield.stringValue.length) {
        [options setObject:self.outputFolderPathTextfield.stringValue forKey:@"-out"];
    }

    //Get scheme
    NSURL *schemaURL = [NSURL fileURLWithPath: self.xsdFilePathTextfield.stringValue];
    if(![fm isReadableFileAtPath: schemaURL.path]) {
        NSRunAlertPanel(@"Error", @"Schema at %@ cannot be found", @"OK", nil, nil, schemaURL.path);
        return;
    }

    //apply custom prefix if set
    id classPrefix = nil;
    if(self.customPrefix.stringValue.length) {
        classPrefix = self.customPrefix.stringValue;
    }
    

    /* Open the schema specified by the user */
    NSError* error = nil;
    
    /* Build the schemea with simple types, complex types, and elements with imported schemas */
    XSDschema* schema = [[XSDschema alloc] initWithUrl: schemaURL targetNamespacePrefix: classPrefix error: &error];
    if(error != nil) {
        NSString *errorString = [error localizedDescription] ? [error localizedDescription] : @"Unknown Error";
        NSRunAlertPanel(@"Error", @"Error while reading XSD %@", @"OK", nil, nil, errorString);
        return;
    }

    /* Escape out of the file path to get to the containing direrctory */
    NSURL* outFolder = [NSURL fileURLWithPath: [fm currentDirectoryPath]];
    if([options objectForKey: @"-out"] != nil) {
        outFolder = [NSURL fileURLWithPath: [options objectForKey:@"-out"]];
    }

    /* Specify the template, the default is the objective-c file defined in our project*/
    NSURL *templateUrl;
    switch (self.templateStyleMatrix.selectedTag) {
        case 3:
            if(!self.templatePathTextfield.stringValue.length) {
                NSRunAlertPanel(@"Error", @"Custom Template selected but no path specified", @"OK", nil, nil);
                return;
            }
            templateUrl = [NSURL fileURLWithPath:self.templatePathTextfield.stringValue];
            break;
        case 2:
            templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-objc" withExtension:@"xml"];
            break;

        case 1:
            templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-swift" withExtension:@"xml"];
            break;
            
        default:
            assert(NO);
    }
    /*************************************************************************************************************************
     *      LOAD THE TEMPLATES USED FOR THE HEADER/CLASS FILES
     *
     *************************************************************************************************************************/
    [schema loadTemplate:templateUrl error:&error];

    /* Ensure that there wasn't an error */
    if(error != nil) {
        NSString *errorString = ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error";
        NSRunAlertPanel(@"Error", @"Error while loading template. %@", @"OK", nil, nil, errorString);
        return;
    }
    
    /* Select the type of code that we want to generate (Framework, Library, or Source Code -- Default for us is source code) */
    XSDschemaGeneratorOptions productTypes = 0;
//    if(self.productTypeDynamicFramework.state==NSOnState) {
//        productTypes |= XSDschemaGeneratorOptionDynamicFramework;
//    }
//    if(self.productTypeStaticFramework.state==NSOnState) {
//        productTypes |= XSDschemaGeneratorOptionStaticFramework;
//    }
    if(self.productTypeSourceCode.state==NSOnState) {
        productTypes |= XSDschemaGeneratorOptionSourceCode;
    }
    
    /*  
     *  Write the code for the types that are currently in use... All the simple types
     *  that are used in the template and generated for our code will be used here
     */
    [schema generateInto:outFolder products:productTypes error:&error];
    if(error != nil) {
        NSString *errorString = ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error";
        NSRunAlertPanel(@"Error", @"Error while generating code. %@", @"OK", nil, nil, errorString);
        return;
    }
    
    /* Success - everything finished without an exception, so show that as an alert to the user */
    NSInteger ret = NSRunAlertPanel(@"Success", @"Generated Code for specified xsd", @"OK", @"Reveal", nil);
    if(ret == NSAlertAlternateReturn) {
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:outFolder.path];
    }
}

#pragma mark help

- (IBAction)showXSDHelp:(id)sender {
    NSInteger res = NSRunInformationalAlertPanel(@"XML Schema Definition", @"The XSD file that describes the 'grammar' for the xml files that parser should be able to parse.\n\nIf you dont have a XSD, but a XML you want to generate a parser for, use a free online services to create a XSD from that XML file",  @"Close", @"Dont have it", nil);
    if(res != NSAlertDefaultReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.freeformatter.com/xsd-generator.html"]];
    }
}

- (IBAction)showCustomTemplateHelp:(id)sender {
    NSInteger res = NSRunInformationalAlertPanel(@"Custom Template", @"This converter uses a template.xml file to map xsd types to Source code-classes and to define how elements are to be parsed.\n\nxsd2cocoa comes with a default template that generates code for ios/osx based on libxml.\n\nIf you want to modify that or add support for new specific simple types, copy the default, rewrite it and supply the new file here", @"I Want a new template", @"Close", nil);
    if(res == NSAlertDefaultReturn) {
        NSSavePanel *p = [NSSavePanel savePanel];
        p.canCreateDirectories = YES;
        [p beginWithCompletionHandler:^(NSInteger result) {
            if(result == NSFileHandlingPanelOKButton) {
                NSURL *templateUrl = [[NSBundle bundleForClass:[XSDschema class]] URLForResource:@"template-swift" withExtension:@"xml"];
                NSURL *destinationUrl = p.URL;
                if([[NSFileManager defaultManager] copyItemAtURL:templateUrl toURL:destinationUrl error:nil]) {
                    [[NSWorkspace sharedWorkspace] openURL:destinationUrl];
                    self.templatePathTextfield.stringValue = destinationUrl.path;
                    [self.templateStyleMatrix selectCellWithTag:3];
                    [self validateWriteButton];
                }
            }
        }];
    }
}

- (IBAction)showPrefixHelp:(id)sender {
    NSRunInformationalAlertPanel(@"Class Prefix", @"This prefix is added to all generated classes and files.\n\nBy default, when left blank, the namespace attribute from the XSD file is used", @"Close", nil, nil);
}

#pragma mark - app delegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
}

#pragma mark - file open panel delegate

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    if(!url.isFileURL) {
        return NO;
    }

    //see if it it's a directory or file
    NSNumber *value;
    [url getResourceValue:&value forKey:NSURLIsDirectoryKey error:NULL];
    if( value.boolValue ) {
        [url getResourceValue:&value forKey:NSURLIsPackageKey error:NULL];
        if(!value.boolValue) {
            return YES;
        }
    }
    else {
        //read the first XMLNode's name (if possible)
        id name = [XMLUtils rootNodeNameFromURL:url];
        if(name) {
            if([name isEqualToString:@"schema"]) {
                return YES;
            }
            else if([name isEqualToString:@"template"]) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - helpers

- (void)validateWriteButton {
    self.writeButton.enabled = NO;
    switch (self.templateStyleMatrix.selectedTag) {
        case 3:
            //if we have all, go
            if(self.templatePathTextfield.stringValue.length) {
                if(self.xsdFilePathTextfield.stringValue.length
                   && self.outputFolderPathTextfield.stringValue.length) {
                    self.writeButton.enabled = YES;
                }
            }
            break;
            default:
            //if we have all, go
            if(self.xsdFilePathTextfield.stringValue.length
               && self.outputFolderPathTextfield.stringValue.length) {
                self.writeButton.enabled = YES;
            }
            break;
    }
}

@end
