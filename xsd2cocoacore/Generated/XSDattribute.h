/*
 XSDattribute.h
 The interface definition of properties and methods for the XSDattribute object.
 Generated by SudzC.com
 */



@class XSDlocalSimpleType;
@class XSDschema;

#import "XSDannotated.h"
#import "XSDanySimpleType.h"



@interface XSDattribute : XSDannotated
{
	NSString* _name;
    NSString* _simpleType;
	NSString* _type; // XSDanySimpleType
	id _use;
	NSString* _defaultValue;
	NSString* _fixed;
	NSString* _form;
    
    XSDschema* _schema;
}

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* simpleType;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) id use;
@property (strong, nonatomic) NSString* defaultValue;
@property (strong, nonatomic) NSString* fixed;
@property (strong, nonatomic) NSString* form;
@property (strong, nonatomic) XSDschema* schema;

- (id) initWithNode: (NSXMLElement*) node schema: (XSDschema*) schema;

- (NSString*) readTemplate;

- (NSString*) variableName;

@end
