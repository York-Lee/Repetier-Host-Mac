#import "ibuttoncrc.h"

@interface CIButtonCrc()

@property int m_crc;
@end

@implementation CIButtonCrc
@synthesize m_crc;

-(void)CIButtonCrc
{
    m_crc = 0;
}

//CIButtonCrc::~CIButtonCrc() {}

-(void)update:(int8_t) data
{
    m_crc = (m_crc ^ data) & 0xff; // i loathe java's promotion rules
    for ( int i = 0; i < 8; i++ ) {
        m_crc = (m_crc & 0x01) ?
                    (((m_crc >> 1) ^ 0x8c) & 0xff) :
                    ((m_crc >> 1) & 0xff);
    }
}

-(int8_t):getcrc
{
    return (int8_t)m_crc;
}

-(void)reset
{
    m_crc = 0;
}

@end

