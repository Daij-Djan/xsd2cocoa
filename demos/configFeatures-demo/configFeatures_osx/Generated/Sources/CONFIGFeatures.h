
/**
 * CONFIGFeatures.h
 * configFeatures.xsd defines a format for testing enumeration support
 */

#import <Foundation/Foundation.h>

@class CONFIGFeature;

@interface CONFIGFeatures : NSObject

@property(nonatomic, readonly) NSArray *features;

/* Returns a dictionary representation of this class (recursivly making
 * dictionaries of properties) */
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface CONFIGFeatures (Reading)

/* The class's initializer used by the reader to build the object structure
 * during parsing (xmlTextReaderPtr at the moment) */
- (id)initWithReader:(void *)reader;

/* Method that is overidden by subclasses that want to extend the base type
 * (xmlTextReaderPtr at the moment) */
- (void)readAttributes:(void *)reader;

@end
