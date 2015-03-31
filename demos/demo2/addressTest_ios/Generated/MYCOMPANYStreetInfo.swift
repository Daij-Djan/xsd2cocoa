import Foundation

class MYCOMPANYStreetInfo {
    let direction: String?
    let name: String?
    let number: String?
    let trailingDirection: String?
    
    var dictionary: Dictionary<String, AnyObject> {
        get {
            var dict = Dictionary<String, AnyObject>()
            
            if(self.direction != nil) { dict["direction"] = self.direction! }
            if(self.name != nil) { dict["name"] = self.name! }
            if(self.number != nil) { dict["number"] = self.number! }
            if(self.trailingDirection != nil) { dict["trailingDirection"] = self.trailingDirection! }
            
            return dict
        }
    }
    
    //MARK: -
    
    func readAttributes(reader: xmlTextReaderPtr) {
    }
    
    init(reader: xmlTextReaderPtr) {
        let _complexTypeXmlDept = xmlTextReaderDepth(reader)

        //read attributes
        self.readAttributes(reader)
        
        //read elements
        var _readerOk = xmlTextReaderRead(reader)
        var _currentNodeType = xmlTextReaderNodeType(reader)
        var _currentXmlDept = xmlTextReaderDepth(reader)
        
        while(_readerOk != 0 && _currentNodeType != 0/*XML_READER_TYPE_NONE*/ && _complexTypeXmlDept < _currentXmlDept) {
            var handledInChild = false
            if(_currentNodeType == 1/*XML_READER_TYPE_ELEMENT*/ || _currentNodeType == 3/*XML_READER_TYPE_TEXT*/) {
                let _currentElementName = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstLocalName(reader)))
                if("direction" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.direction = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("name" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.name = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("number" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.number = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("trailingDirection" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.trailingDirection = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                } else   {
                    println("Ignoring unexpected: \(_currentElementName)")
                    break
                }
            }
            
            _readerOk = handledInChild ? xmlTextReaderReadState(reader) : xmlTextReaderRead(reader)
            _currentNodeType = xmlTextReaderNodeType(reader)
            _currentXmlDept = xmlTextReaderDepth(reader)
        }
    }
}