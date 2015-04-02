#import <Foundation/Foundation.h>

@interface CIButtonCrc : NSObject
//@property int m_crc;

-(void)CIButtonCrc;
//~CIButtonCrc();
-(void)update:(int8_t) data;
-(uint8_t)getcrc;
-(void)reset;
@end
