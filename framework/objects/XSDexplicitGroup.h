#import "XSSchemaNode.h"

@interface XSDexplicitGroup : XSSchemaNode

@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSString* ref;
@property (readonly, nonatomic) NSArray* elements;

@end
