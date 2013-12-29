/*
	XSDlocalComplexType.h
	The interface definition of properties and methods for the XSDlocalComplexType object.
	Generated by SudzC.com
*/
#import "XMLUtils.h"


	

@interface XSDlocalComplexType : NSObject

{
	id _name;
	id _abstract;
	id _final;
	id _block;
	
}
		
	@property (strong, nonatomic) id name;
	@property (strong, nonatomic) id abstract;
	@property (strong, nonatomic) id final;
	@property (strong, nonatomic) id block;

	- (id) initWithNode: (NSXMLNode*) node;

@end
