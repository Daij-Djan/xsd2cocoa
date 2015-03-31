
/**
WLGroupdef.h

weblinks_groups.xsd extends a format for saving links defined by weblinks.xsd by
adding support for groups
*/
#import <Foundation/Foundation.h>

#import "WLFG.h"

@class WLDescription;

/**
this type defines a group of links - a group has a name and can have subgroups
*/
@interface WLGroupdef : WLFG

/**
this attribute is required and stores the display name of the group
*/
@property(nonatomic, readonly) NSString *name;

/**
these elements is a description
*/
@property(nonatomic, readonly) WLDescription *elementDescription;

/**
returns a dictionary representation of this class (recursivly making
dictionaries of properties)
*/
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface WLGroupdef (Reading)

/**
the class's initializer used by the reader to build the object structure during
parsing (xmlTextReaderPtr at the moment)
*/
- (id)initWithReader:(void *)reader;

/**
Method that is overidden by subclasses that want to extend the base type
(xmlTextReaderPtr at the moment)
*/
- (void)readAttributes:(void *)reader;

@end
