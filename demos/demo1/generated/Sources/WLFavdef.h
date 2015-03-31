
/**
WLFavdef.h

weblinks.xsd defines a format for saving links to your favourite websites
*/
#import <Foundation/Foundation.h>

/**
this type defines how a link is represented. It has textual content (name) and a
link attribute
*/
@interface WLFavdef : NSObject

/**
this attribute is required and stores the absolute url of the link
*/
@property(nonatomic, readonly) NSURL *link;

/**
the type's main NSString value
*/
@property(nonatomic, readonly) NSString *value;

/**
returns a dictionary representation of this class (recursivly making
dictionaries of properties)
*/
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface WLFavdef (Reading)

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
