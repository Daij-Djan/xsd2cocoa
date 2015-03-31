import Foundation

class MYCOMPANYAddress {
    let addressLine1: String?
    let addressLine2: String?
    let addressMatch: Bool?
    let city: String?
    let country: String?
    let postOfficeBox: String?
    let state: String?
    let streetInfo: MYCOMPANYStreetInfo?
    let streetName: String?
    let unitInfo: MYCOMPANYUnitInfo?
    let zipCode: String?
    
    var dictionary: Dictionary<String, AnyObject> {
        get {
            var dict = Dictionary<String, AnyObject>()
            
            if(self.addressLine1 != nil) { dict["addressLine1"] = self.addressLine1! }
            if(self.addressLine1 != nil) { dict["addressLine2"] = self.addressLine2! }
            if(self.addressMatch != nil) { dict["addressMatch"] = self.addressMatch! }
            if(self.city != nil) { dict["city"] = self.city! }
            if(self.country != nil) { dict["country"] = self.country! }
            if(self.postOfficeBox != nil) { dict["postOfficeBox"] = self.postOfficeBox! }
            if(self.state != nil) { dict["state"] = self.state! }
            if(self.streetInfo != nil) { dict["streetInfo"] = self.streetInfo!.dictionary }
            if(self.streetName != nil) { dict["streetName"] = self.streetName! }
            if(self.unitInfo != nil) { dict["unitInfo"] = self.unitInfo!.dictionary }
            if(self.zipCode != nil) { dict["zipCode"] = self.zipCode! }
            
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
                if("addressLine1" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.addressLine1 = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("addressLine2" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.addressLine2 = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("addressMatch" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    let str = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    self.addressMatch = (str == "true")
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("city" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.city = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("country" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.country = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("postOfficeBox" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.postOfficeBox = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("state" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.state = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("streetInfo" == _currentElementName) {
                    self.streetInfo = MYCOMPANYStreetInfo(reader: reader)
                    handledInChild = true
                } else if("streetName" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.streetName = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    
                } else if("unitInfo" == _currentElementName) {
                    self.unitInfo = MYCOMPANYUnitInfo(reader: reader)
                    handledInChild = true
                } else if("zipCode" == _currentElementName) {
                    _readerOk = xmlTextReaderRead(reader)
                    _currentNodeType = xmlTextReaderNodeType(reader)
                    self.zipCode = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
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
