//
//  XSDAnnotation.h
//  XSDConverter
//
//  Created by Dominik Pich on 26/12/14.
//
//

#import "XSSchemaNode.h"
#import "XMLUtils.h"

@interface XSDAnnotation : XSSchemaNode

@property(nonatomic, readonly) NSString *identifier;
@property(nonatomic, readonly) NSString *appInfo;
@property(nonatomic, readonly) NSString *documentation;

- (NSString*)comment;

@end
