
#import "MYCOMPANYAddress.h"

#import "MYCOMPANYStreetInfo.h"
#import "MYCOMPANYUnitInfo.h"


@interface MYCOMPANYAddress ()

@property (nonatomic, readwrite) NSString* addressLine1
@property (nonatomic, readwrite) NSString* addressLine2
@property (nonatomic, readwrite) NSNumber* addressMatch
@property (nonatomic, readwrite) NSString* city
@property (nonatomic, readwrite) NSString* country
@property (nonatomic, readwrite) NSString* postOfficeBox
@property (nonatomic, readwrite) NSString* state
@property (nonatomic, readwrite) MYCOMPANYStreetInfo* streetInfo
@property (nonatomic, readwrite) NSString* streetName
@property (nonatomic, readwrite) MYCOMPANYUnitInfo* unitInfo
@property (nonatomic, readwrite) NSString* zipCode



@end

@implementation MYCOMPANYAddress 
 
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
          self.addressMatch = [NSNumber numberWithBool: [[NSString stringWithCString: (const char*) xmlTextReaderConstValue(reader) encoding: NSUTF8StringEncoding] == @"true"]]
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
          self.streetInfo = [[MYCOMPANYStreetInfo alloc] initWithReader: reader]
          
          handledInChild = YES
        } else if("streetName" == _currentElementName) {
          _readerOk = xmlTextReaderRead(reader)
_currentNodeType = xmlTextReaderNodeType(reader)
          self.streetName = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
          _readerOk = xmlTextReaderRead(reader)
_currentNodeType = xmlTextReaderNodeType(reader)
          
        } else if("unitInfo" == _currentElementName) {
          self.unitInfo = [[MYCOMPANYUnitInfo alloc] initWithReader: reader]
          
          handledInChild = YES
        } else if("zipCode" == _currentElementName) {
          _readerOk = xmlTextReaderRead(reader)
_currentNodeType = xmlTextReaderNodeType(reader)
          self.zipCode = String.fromCString(UnsafeMutablePointer<CChar>(xmlTextReaderConstValue(reader)))
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
    

 
     if(self.addressLine1) [dict setObject:self.addressLine1 forKey:@"addressLine1"]
 
     if(self.addressLine2) [dict setObject:self.addressLine2 forKey:@"addressLine2"]
 
     if(self.addressMatch) [dict setObject:self.addressMatch forKey:@"addressMatch"]
 
     if(self.city) [dict setObject:self.city forKey:@"city"]
 
     if(self.country) [dict setObject:self.country forKey:@"country"]
 
     if(self.postOfficeBox) [dict setObject:self.postOfficeBox forKey:@"postOfficeBox"]
 
     if(self.state) [dict setObject:self.state forKey:@"state"]
 
    
        if(self.streetInfo) {
            NSDictionary *streetInfoDict = [self.streetInfo valueForKeyPath:@"dictionary"]
            [dict setObject:streetInfoDict forKey:@"streetInfo"]
            }
    
 
     if(self.streetName) [dict setObject:self.streetName forKey:@"streetName"]
 
    
        if(self.unitInfo) {
            NSDictionary *unitInfoDict = [self.unitInfo valueForKeyPath:@"dictionary"]
            [dict setObject:unitInfoDict forKey:@"unitInfo"]
            }
    
 
     if(self.zipCode) [dict setObject:self.zipCode forKey:@"zipCode"]



    return dict
}
 @end
	    