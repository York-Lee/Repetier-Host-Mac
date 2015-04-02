#import "packetbuilder.h"
#import "packetconstants.h"

@implementation CPacketBuilder

-(id)init
{
    assert(0);
    return self;
}

//CPacketBuilder::~CPacketBuilder() {}

-(id)init:(int) command
{
    m_idx = 2;
    m_data[0] = START_BYTE;
    // data[1] = length; // just to avoid confusion
    [self add8:(int8_t)command];
    return self;
}

-(void)add8:(int) v
{
    m_data[m_idx++] = (int8_t)v;
    [m_crc update:(int8_t)v];
}

-(void)add16:(int) v
{
    [self add8:(int8_t)(v & 0xff)];
    [self add8:(int8_t)((v >> 8) & 0xff)];
}

-(void)add32:(long) v
{
    [self add16:(int)(v & 0xffff)];
    [self add16:(int)((v >> 16) & 0xffff)];
}

-(void)addFloat:(float) v
{
    unsigned char* buff = (unsigned char*)(&v);
    [self add8:buff[0]]; [self add8:buff[1]];
    [self add8:buff[2]]; [self add8:buff[3]];
}

-(int)addString:(NSString*) str :(int) maxSize
{
    int i = 0, size = maxSize;
    while ( size > 0 && i < [str length] ) {
        char ch = [str characterAtIndex:(i)];
        [self add8:(int)(ch - '0')];
        i++; size--;
    }
    [self add8:'\0'];
    return i;
}

-(NSData*)getPacket
{
    m_data[m_idx] = [m_crc getcrc];
    m_data[1] = (int8_t)(m_idx - 2);    // len does not count packet header

    Byte* ba = (Byte*)malloc(m_idx+1); //ba.resize(m_idx+1);
    memcpy(ba, m_data, m_idx+1);
    NSData * ba_data = [[NSData alloc] initWithBytes:ba length:m_idx+1];
    for (int i = 0; i < m_idx + 1; i++) {
        NSLog(@"%d", ba[i]);
    }
    return ba_data;
}

@end





