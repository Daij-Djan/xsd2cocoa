
#import "MYCOMPANYStreetInfo.h"



@interface MYCOMPANYStreetInfo ()

@property (nonatomic, readwrite) NSString* direction
@property (nonatomic, readwrite) NSString* name
@property (nonatomic, readwrite) NSString* number
@property (nonatomic, readwrite) NSString* trailingDirection



@end

@implementation MYCOMPANYStreetInfo 
 
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
    

 
     if(self.direction) [dict setObject:self.direction forKey:@"direction"]
 
     if(self.name) [dict setObject:self.name forKey:@"name"]
 
     if(self.number) [dict setObject:self.number forKey:@"number"]
 
     if(self.trailingDirection) [dict setObject:self.trailingDirection forKey:@"trailingDirection"]



    return dict
}
 @end
	    