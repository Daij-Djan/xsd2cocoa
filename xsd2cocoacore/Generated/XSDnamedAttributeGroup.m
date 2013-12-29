/*
	XSDnamedAttributeGroup.h
	The implementation of properties and methods for the XSDnamedAttributeGroup object.
	Generated by SudzC.com
*/
#import "XSDnamedAttributeGroup.h"
#import "XSDNCName.h"

@implementation XSDnamedAttributeGroup
	@synthesize name = _name;
	@synthesize ref = _ref;

	- (id) init
	{
		if(self = [super init])
		{
			self.name = nil; // [[XSDanySimpleType alloc] init];

		}
		return self;
	}

	- (id) initWithNode: (NSXMLNode*) node {
		if(self = [super init])
		{
#pragma mark ?
			self.name = [[(id)[XSDNCName alloc] initWithNode: [XMLUtils getNode: node withName: @"name"]] object];
			self.ref = [[XMLUtils getNode: node withName: @"ref"] objectValue];
		}
		return self;
	}

@end