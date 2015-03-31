
/**
WLFG.h

weblinks.xsd defines a format for saving links to your favourite websites
*/
#import <Foundation/Foundation.h>

@class WLFavdef;
@class WLGroupdef;

/**
this type defines a mixed collection of link items and/or groups of links
*/
@interface WLFG : NSObject

/**
these elements represent link items
*/
@property(nonatomic, readonly) NSArray *favitems;

/**
these elements represent groups of links
*/
@property(nonatomic, readonly) NSArray *groups;

/**
returns a dictionary representation of this class (recursivly making
dictionaries of properties)
*/
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface WLFG (Reading)

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
