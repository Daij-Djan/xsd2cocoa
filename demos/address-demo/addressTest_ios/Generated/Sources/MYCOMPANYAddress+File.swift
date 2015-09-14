import Foundation

extension MYCOMPANYAddress {
/**
 * Name:            FromURL
 * Parameters:      (NSURL*) - the location of the XML file as a NSURL representation
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate a MYCOMPANYAddress object from the path
 *                  specified by the user
 */
	class func fromURL(url : NSURL)->MYCOMPANYAddress?{
		if let s = url.absoluteString?.cStringUsingEncoding(NSUTF8StringEncoding)
		{
			let reader = xmlReaderForFile(s, nil, 0 /*options*/)

			    if (reader != nil) {
				let ret = xmlTextReaderRead(reader)
				    if (ret == 1 /*XML_READER_TYPE_ELEMENT*/) {
					return MYCOMPANYAddress(reader : reader)
				}
				xmlFreeTextReader(reader)
			}
		}
		return nil
	}

/**
 * Name:            FromFile
 * Parameters:      (NSString*) - the location of the XML file as a string
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate a MYCOMPANYAddress object from the path
 *                  specified by the user
 */
	class func fromFile(path : String)->MYCOMPANYAddress?{
		if let url = NSURL(fileURLWithPath : path)
		{
			return self.fromURL(url)
		}
		return nil
	}

/**
 * Name:            FromData:
 * Parameters:      (NSData *)
 * Returns:         A generated MYCOMPANYAddress object
 * Description:     Generate the MYCOMPANYAddress object from the NSData
 *                  object generated from the XML.
 */
	class func fromData(data : NSData)->MYCOMPANYAddress?{
		let bytes = UnsafePointer < Int8 > (data.bytes)
		    let length = Int32(data.length)
		        let reader = xmlReaderForMemory(bytes, length, nil, nil, 0 /*options*/)

		            if (reader != nil) {
			let ret = xmlTextReaderRead(reader)
			    if (ret > 0) {
				return MYCOMPANYAddress(reader : reader)
			}
			xmlFreeTextReader(reader)
		}

		return nil
	}
}
