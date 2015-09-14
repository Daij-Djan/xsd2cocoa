
            import Foundation
            
            @objc
            class MYCOMPANYStreetInfo {

            
                var direction: String?
                var name: String?
                var number: String?
                var trailingDirection: String?
            
            

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
 * Description: Iterate through the XML and create the MYCOMPANYStreetInfo object
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
            if("direction" == _currentElementName) {
            
				_readerOk = xmlTextReaderRead(reader)
				_currentNodeType = xmlTextReaderNodeType(reader)
				
                    self.direction = String.fromCString(UnsafePointer<CChar>(directionElementValue))
                    
				_readerOk = xmlTextReaderRead(reader)
				_currentNodeType = xmlTextReaderNodeType(reader)
				{% /if }
            } else 