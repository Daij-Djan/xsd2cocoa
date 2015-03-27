//
//  XSDenumeration.h
//  XSDConverter
//
//  Created by Alex Smith on 3/25/15.
//
//

#import "XSSchemaNode.h"

@interface XSDenumeration : XSSchemaNode

/* This is for the values of the enumeration */
@property (readonly, nonatomic) NSString* value;
/* This is used for the baseType */
@property (readonly, nonatomic) NSString* type;

/* This is used for storing the code that is in our template for the base type */
@property (readonly, nonatomic) NSString* readCodeForAttribute;

@end
