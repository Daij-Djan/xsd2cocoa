/*
	XSDnoFixedFacet.h
	The implementation of properties and methods for the XSDnoFixedFacet object.
	Generated by SudzC.com
*/
#import "XSDnoFixedFacet.h"

@implementation XSDnoFixedFacet
	@synthesize fixed = _fixed;

	- (id) init
	{
		if(self = [super init])
		{

		}
		return self;
	}

	- (id) initWithNode: (NSXMLNode*) node {
		if(self = [super init])
		{
			self.fixed = [[XMLUtils getNode: node withName: @"fixed"] objectValue];
		}
		return self;
	}


@end
