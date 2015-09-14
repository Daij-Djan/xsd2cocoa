//
//  XSDschema+XPaths.h
//  XSDConverter
//
//  Created by Dominik Pich on 29/06/15.
//
//

#import <XSDConverterCore/XSDConverterCore.h>

@interface XSDschema (XPaths)

- (NSString*)XPathForSchemaSimpleTypes;

- (NSString*)XPathForSchemaComplexTypes;

- (NSString*)XPathForSchemaGlobalElements;

- (NSString*)XPathForSchemaIncludes;

- (NSString*)XPathForSchemaImports;

- (NSString*)XPathForTemplateAdditionalFiles;

- (NSString*)XPathForTemplateFormatStyles;

- (NSString*)XPathForTemplateFirstEnumeration;

- (NSString*)XPathForTemplateReads;

- (NSString*)XPathForTemplateFirstImplementationHeaders;

- (NSString*)XPathForTemplateFirstImplementationClasses;

- (NSString*)XPathForTemplateFirstReaderHeaders;

- (NSString*)XPathForTemplateFirstReaderClasses;

- (NSString*)XPathForTemplateFirstComplexType;

- (NSString*)XPathForTemplateSimpleTypes;

- (NSString*)XPathForTemplateFirstElementRead;

+ (NSString*)XPathForNamechanges;

@end
