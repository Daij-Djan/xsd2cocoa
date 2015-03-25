//
//  XSDenumeration.h
//  XSDConverter
//
//  Created by Alex Smith on 3/25/15.
//
//

#import "XSSchemaNode.h"

@interface XSDenumeration : XSSchemaNode

@property (readonly, nonatomic) NSString* value;
@property (readonly, nonatomic) NSString* type;

@end
