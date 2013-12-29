//
//  XmlAccess.h
//  xsd2cocoa
//
//  Created by Stefan Winter on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMLUtils.h"
#import "XSDschema.h"

@interface XSSchemaNode : NSObject {
@private
    XSDschema* _schema;
}

@property (nonatomic, strong) XSDschema* schema;

+ (NSNumber*) node: (NSXMLElement*) node boolAttribute: (NSString*) attribute;
+ (NSString*) node: (NSXMLElement*) node stringAttribute: (NSString*) attribute;
+ (NSNumber*) node: (NSXMLElement*) node intAttribute: (NSString*) attribute;
+ (NSXMLElement*) node: (NSXMLElement*) element childWithName: (NSString*) name;

+ (NSArray*) node: (NSXMLElement*) element childrenWithName: (NSString*) name;
+ (NSArray*) node: (NSXMLElement*) element descendantsWithName: (NSString*) name;
    
- (id) initWithSchema: (XSDschema*) schema;

@end
