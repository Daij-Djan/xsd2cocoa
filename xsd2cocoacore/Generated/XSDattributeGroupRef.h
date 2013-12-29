/*
	XSDattributeGroupRef.h
	The interface definition of properties and methods for the XSDattributeGroupRef object.
	Generated by SudzC.com
*/


#import "XSDanySimpleType.h"

@interface XSDattributeGroupRef : NSObject

{
	XSDanySimpleType* _ref;
	id _name;
	
}
		
	@property (strong, nonatomic) XSDanySimpleType* ref;
	@property (strong, nonatomic) id name;

	- (id) initWithNode: (NSXMLNode*) node;

@end
