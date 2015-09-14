
            import Foundation
            
            @objc
            class MYCOMPANYAddress {

            
                var addressLine1: String?
                var addressLine2: String?
                var addressMatch: Bool?
                var city: String?
                var country: String?
                var postOfficeBox: String?
                var state: String?
                var streetInfo: MYCOMPANYStreetInfo?
                var streetName: String?
                var unitInfo: MYCOMPANYUnitInfo?
                var zipCode: String?
            
            

 /**
 * Name:        readAttributes
 * Parameters:  (void *) - the Libxml's xmlTextReader pointer
 * Returns:     (void)
 * Description: Read the attributes for the current XML element
 */
            func readAttributes(reader: xmlTextReaderPtr) {
            
            
            }

/**
 * Name:        initWithReader
 * Parameters:  (void *) - the Libxml's xmlTextReader pointer
 * Returns:     returns the classes created object
 * Description: Iterate through the XML and create the MYCOMPANYAddress object
 */
            init(reader: xmlTextReaderPtr) {
            let _complexTypeXmlDept = xmlTextReaderDepth(reader)
            
            
            self.readAttributes(reader)
            
            
            
            
            
            
            
            
            
            
            
            
            
            var _readerOk = xmlTextReaderRead(reader)
            var _currentNodeType = xmlTextReaderNodeType(reader)
            var _currentXmlDept = xmlTextReaderDepth(reader)
            
            while(_readerOk > 0 && _currentNodeType != 0/*XML_READER_TYPE_NONE*/ && _complexTypeXmlDept < _currentXmlDept) {
            var handledInChild = false
            if(_currentNodeType == 1/*XML_READER_TYPE_ELEMENT*/ || _currentNodeType == 3/*XML_READER_TYPE_TEXT*/) {
            let _currentElementNameXmlChar = xmlTextReaderConstLocalName(reader)
            let _currentElementName = String.fromCString(UnsafePointer<CChar>(_currentElementNameXmlChar))
            if("addressLine1" == _currentElementName) {
            
				_readerOk = xmlTextReaderRead(reader)
				_currentNodeType = xmlTextReaderNodeType(reader)
				
                    self.addressLine1 = String.fromCString(UnsafePointer<CChar>(addressLine1ElementValue))
                    
				_readerOk = xmlTextReaderRead(reader)
				_currentNodeType = xmlTextReaderNodeType(reader)
				{% /if }
            } else 