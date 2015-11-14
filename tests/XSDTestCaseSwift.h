//
//  XSDTest.h
//  XSDConverter
//
//  Created by Dominik Pich on 24/12/14.
//
//

#import "XSDTestCase.h"

@interface XSDTestCaseSwift : XSDTestCase
- (NSNumber*)reflect:(id)obj numberForKey:(NSString*)propertyName;
@end
