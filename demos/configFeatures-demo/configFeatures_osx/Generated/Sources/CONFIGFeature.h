
/**
 * CONFIGFeature.h
 * configFeatures.xsd defines a format for testing enumeration support
 */

#import <Foundation/Foundation.h>

#import "CONFIGFeatureNameEnum.h"

@interface CONFIGFeature : NSObject

@property(nonatomic, readonly) CONFIGFeatureNameEnum identifier;

@property(nonatomic, readonly) NSNumber *enabled;

/* Returns a dictionary representation of this class (recursivly making
 * dictionaries of properties) */
@property(nonatomic, readonly) NSDictionary *dictionary;

@end

@interface CONFIGFeature (Reading)

/* The class's initializer used by the reader to build the object structure
 * during parsing (xmlTextReaderPtr at the moment) */
- (id)initWithReader:(void *)reader;

/* Method that is overidden by subclasses that want to extend the base type
 * (xmlTextReaderPtr at the moment) */
- (void)readAttributes:(void *)reader;

@end
