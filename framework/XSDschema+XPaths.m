//
//  XSDschema+XPaths.m
//  XSDConverter
//
//  Created by Dominik Pich on 29/06/15.
//
//

#import "XSDschema+XPaths.h"

@implementation XSDschema (XPaths)

- (NSString*)XPathForSchemaSimpleTypes {
    id path = [NSString stringWithFormat:@"/%@/%@",
               [self nameSpacedSchemaNodeNameForNodeName:@"schema"],
               [self nameSpacedSchemaNodeNameForNodeName:@"simpleType"]];
    return path;
}

- (NSString*)XPathForSchemaComplexTypes {
    id path = [NSString stringWithFormat:@"/%@/%@",
               [self nameSpacedSchemaNodeNameForNodeName:@"schema"],
               [self nameSpacedSchemaNodeNameForNodeName:@"complexType"]];
    return path;
}

- (NSString*)XPathForSchemaGlobalElements {
    id path = [NSString stringWithFormat:@"/%@/%@",
               [self nameSpacedSchemaNodeNameForNodeName:@"schema"],
               [self nameSpacedSchemaNodeNameForNodeName:@"element"]];
    return path;
}

- (NSString*)XPathForSchemaIncludes {
    id path = [NSString stringWithFormat:@"/%@/%@",
               [self nameSpacedSchemaNodeNameForNodeName:@"schema"],
               [self nameSpacedSchemaNodeNameForNodeName:@"include"]];
    return path;
}

- (NSString*)XPathForSchemaImports {
    id path = [NSString stringWithFormat:@"/%@/%@",
               [self nameSpacedSchemaNodeNameForNodeName:@"schema"],
               [self nameSpacedSchemaNodeNameForNodeName:@"import"]];
    return path;
}

- (NSString*)XPathForTemplateAdditionalFiles {
    return @"/template[1]/additional_file";
}

- (NSString*)XPathForTemplateFormatStyles {
    return @"/template[1]/format_style";
}

- (NSString*)XPathForTemplateFirstEnumeration {
    return @"/template[1]/enumeration[1]";
}

- (NSString*)XPathForTemplateReads {
    return @"read";
}

- (NSString*)XPathForTemplateFirstImplementationHeaders {
    return @"implementation[1]/header";
}

- (NSString*)XPathForTemplateFirstImplementationClasses {
    return @"implementation[1]/class";
}

- (NSString*)XPathForTemplateFirstReaderHeaders {
    return @"reader[1]/header";
}

- (NSString*)XPathForTemplateFirstReaderClasses {
    return @"reader[1]/class";
}

- (NSString*)XPathForTemplateFirstComplexType {
    return @"/template[1]/complextype[1]";
}

- (NSString*)XPathForTemplateSimpleTypes {
    return @"/template[1]/simpletype";
}

- (NSString*)XPathForTemplateFirstElementRead {
    return @"read[1]/element[1]";
}

+ (NSString*)XPathForNamechanges {
    return @"/nameChanges/nameChange";
}

@end
