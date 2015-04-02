#import <Foundation/Foundation.h>

@interface CIButtonCrc : NSObject
//@property int m_crc;

-(id)init;
//~CIButtonCrc();
-(void)update:(uint8_t) data;
-(uint8_t)getcrc;
-(void)reset;
@end
