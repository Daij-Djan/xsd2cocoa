
/**
WLDescription.h

weblinks_test.xsd extends a format for saving links defined by weblinks.xsd by
adding support for descriptions of groups (mainly to test import)
*/
#import <Foundation/Foundation.h>

/**
this type defines an annotation
*/
@interface WLDescription : NSObject

/**
this attribute is required and stores an user-defined identifier for this note
*/
@property(nonatomic, readonly) NSString *identifier;

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

@interface WLDescription (Reading)

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
