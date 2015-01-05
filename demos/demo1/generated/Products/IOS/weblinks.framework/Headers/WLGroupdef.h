
/**
WLGroupdef.h

weblinks.xsd defines a format for saving links to your favourite websites
*/
#import <Foundation/Foundation.h>
//RM #import <libxml/xmlreader.h>

#import "WLFG.h"



/**
this type defines a group of links - a group has a name and can have subgroups
*/
@interface WLGroupdef : WLFG

/**
this attribute is required and stores the display name of the group
*/
@property (nonatomic, readonly) NSString* name;



/**
returns a dictionary representation of this class (recursivly making dictionaries of properties)
*/
@property (nonatomic, readonly) NSDictionary* dictionary;

@end

@interface WLGroupdef (Reading)

/**
the class's initializer used by the reader to build the object structure during parsing (xmlTextReaderPtr at the moment)
*/
- (id) initWithReader: (void*) reader;

/**
Method that is overidden by subclasses that want to extend the base type (xmlTextReaderPtr at the moment)
*/
- (void) readAttributes: (void*) reader;

@end
	