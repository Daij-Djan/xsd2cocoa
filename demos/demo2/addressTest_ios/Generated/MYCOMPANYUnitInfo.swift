import Foundation

class MYCOMPANYUnitInfo {
    let number: String?
    let type: String?
    
    var dictionary: Dictionary<String, AnyObject> {
        get {
            var dict = Dictionary<String, AnyObject>()
            
            if(self.number != nil) { dict["number"] = self.number! }
            if(self.type != nil) { dict["type"] = self.type! }
            
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
                
                if("number" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.number = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("type" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.type = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
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
