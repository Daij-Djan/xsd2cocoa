
#import "MYCOMPANYAddress+File.h"
        
@implementation MYCOMPANYAddress (File)

+ (MYCOMPANYAddress*)AddressFromURL:(NSURL*)url {
    MYCOMPANYAddress* obj = nil;
    xmlTextReaderPtr reader = xmlReaderForFile( url.absoluteString.UTF8String,
                                               NULL,
                                               (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
    if(reader != nil) {
        int ret = xmlTextReaderRead(reader);
        if(ret == XML_READER_TYPE_ELEMENT) {
            obj = [[MYCOMPANYAddress alloc] initWithReader: reader];
        }
        xmlFreeTextReader(reader);
    }
    return obj;
}

+ (MYCOMPANYAddress*)AddressFromFile:(NSString*)path {
    return [self AddressFromURL:[NSURL fileURLWithPath:path]];
}

+ (MYCOMPANYAddress*)AddressFromData:(NSData*)data {
    MYCOMPANYAddress* obj = nil;
    xmlTextReaderPtr reader = xmlReaderForMemory([data bytes],
                                                 (int)[data length],
                                                 NULL,
                                                 NULL,
                                                 (XML_PARSE_NOBLANKS | XML_PARSE_NOCDATA | XML_PARSE_NOERROR | XML_PARSE_NOWARNING));
    if(reader != nil) {
        int ret = xmlTextReaderRead(reader);
        if(ret > 0) {
            obj = [[MYCOMPANYAddress alloc] initWithReader: reader];
        }
        xmlFreeTextReader(reader);
    }
    return obj;        
}

@end
	