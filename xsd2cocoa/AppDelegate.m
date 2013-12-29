//
//  AppDelegate.m
//  xsd2cocoa
//
//  Created by Dominik Pich on 11/12/13.
//
//

#import "AppDelegate.h"
#import "XSDschema.h"
#import "XMLUtils.h"

@interface AppDelegate () <NSOpenSavePanelDelegate>
@end

@implementation AppDelegate

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
                        }
                        else if([name isEqualToString:@"template"]) {
                            self.templatePathTextfield.stringValue = url.path;
                        }
                    }
                }
            }
        }
    }];
}

- (IBAction)writeObjcCode:(id)sender {
    NSFileManager* fm = [NSFileManager defaultManager];
    
    //get dir if specified
    NSMutableDictionary* options = [NSMutableDictionary dictionary];
    if(self.outputFolderPathTextfield.stringValue.length) {
        [options setObject:self.outputFolderPathTextfield.stringValue forKey:@"-out"];
    }

    //Get scheme
    NSURL *schemaURL = [NSURL fileURLWithPath: self.xsdFilePathTextfield.stringValue];
    if(![fm isReadableFileAtPath: [schemaURL path]]) {
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"Schema at %@ cannot be found", [schemaURL path]], @"OK", nil, nil);
        return;
    }
    
    //open scheme
    NSError* error = nil;
    XSDschema* schema = [[XSDschema alloc] initWithUrl: schemaURL prefix: nil error: &error];
    if(error != nil) {
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"Error while reading XSD %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error"], @"OK", nil, nil);
        return;
    }

    //get out folder
    NSURL* outFolder = [NSURL fileURLWithPath: [fm currentDirectoryPath]];
    if([options objectForKey: @"-out"] != nil) {
        outFolder = [NSURL fileURLWithPath: [options objectForKey:@"-out"]];
    }

    //find template path
    NSURL *templateUrl;
    switch (self.templateStyleMatrix.selectedTag) {
        case 2:
            if(!self.templatePathTextfield.stringValue.length) {
                NSRunAlertPanel(@"Error", @"Custom Template selected but no path specified", @"OK", nil, nil);
                return;
            }
            templateUrl = [NSURL fileURLWithPath:self.templatePathTextfield.stringValue];
            break;
        case 1:
            templateUrl = [[NSBundle mainBundle] URLForResource:@"template-default" withExtension:@"xml"];
            break;
        case 0:
            templateUrl = [[NSBundle mainBundle] URLForResource:@"template-filterable" withExtension:@"xml"];
            break;
    }
    
    //load template
    [schema loadTemplate: templateUrl error: &error];
    if(error != nil) {
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"Error while assigning template %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error"], @"OK", nil, nil);
        return;
    }

    //write out data
    [schema generateInto: outFolder copyAdditionalFiles:YES error: &error];
    if(error != nil) {
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error"], @"OK", nil, nil);
        return;
    }

    //success
    NSInteger ret = NSRunAlertPanel(@"Success", @"Generated Code for specified xsd", @"OK", @"Reveal", nil);
    if(ret == NSAlertAlternateReturn) {
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:outFolder.path];
    }
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

@end
