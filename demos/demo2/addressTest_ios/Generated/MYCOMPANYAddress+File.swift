import Foundation

extension MYCOMPANYAddress {
    class func AddressFromURL(url:NSURL) -> MYCOMPANYAddress? {
        let s = (url.absoluteString! as NSString).UTF8String
        let reader = xmlReaderForFile( s, nil, 0/*options*/)
        
        if(reader != nil) {
            let ret = xmlTextReaderRead(reader)
            if(ret == 1/*XML_READER_TYPE_ELEMENT*/) {
                return MYCOMPANYAddress(reader: reader)
            }
            xmlFreeTextReader(reader)
        }
        
        return nil
    }
    
    class func AddressFromFile(path:String) -> MYCOMPANYAddress? {
        let url = NSURL(fileURLWithPath:path)
        return url != nil ? self.AddressFromURL(url!) : nil
    }

    class func AddressFromData(data:NSData) -> MYCOMPANYAddress? {
        let bytes = UnsafePointer<Int8>(data.bytes)
        let length = Int32(data.length)
        let reader = xmlReaderForMemory(bytes, length, nil, nil, 0/*options*/)
        
        if(reader != nil) {
            let ret = xmlTextReaderRead(reader)
            if(ret > 0) {
                return MYCOMPANYAddress(reader: reader)
            }
            xmlFreeTextReader(reader)
        }
        
        return nil
    }
}