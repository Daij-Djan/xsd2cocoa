
#import "MYCOMPANYUnitInfo.h"



@interface MYCOMPANYUnitInfo ()

@property (nonatomic, readwrite) NSString* number
@property (nonatomic, readwrite) NSString* type



@end

@implementation MYCOMPANYUnitInfo 
 
- (void) readAttributes: (xmlTextReaderPtr) reader {
}

- (id) initWithReader: (xmlTextReaderPtr) reader {

  int _complexTypeXmlDept = xmlTextReaderDepth(reader)
  self = [super init]
  if(self) {
    
  [self readAttributes: reader]

    
    

//    NSLog(@"Parsing %@", NSStringFromClass(self.class))

    int _readerOk = xmlTextReaderRead(reader)
    int _currentNodeType = xmlTextReaderNodeType(reader)
    int _currentXmlDept = xmlTextReaderDepth(reader)
    while(_readerOk && _currentNodeType != XML_READER_TYPE_NONE && _complexTypeXmlDept < _currentXmlDept) {
      BOOL handledInChild = NO
      if(_currentNodeType == XML_READER_TYPE_ELEMENT || _currentNodeType == XML_READER_TYPE_TEXT) {
        NSString* _currentElementName = [NSString stringWithCString: (const char*) xmlTextReaderConstLocalName(reader) encoding:NSUTF8StringEncoding]
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
          NSLog(@"Ignoring unexpected: %@", _currentElementName)
            break
        }
      }
      
      _readerOk = handledInChild ? xmlTextReaderReadState(reader) : xmlTextReaderRead(reader)
      _currentNodeType = xmlTextReaderNodeType(reader)
      _currentXmlDept = xmlTextReaderDepth(reader)
    }
    
    
    
  }
  return self
}
 
- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary]
    

 
     if(self.number) [dict setObject:self.number forKey:@"number"]
 
     if(self.type) [dict setObject:self.type forKey:@"type"]



    return dict
}
 @end
	    