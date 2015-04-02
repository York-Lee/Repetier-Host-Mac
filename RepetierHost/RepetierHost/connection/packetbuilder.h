#ifndef PACKETBUILDER_H
#define PACKETBUILDER_H

//#include <QtGlobal>
//#include <QByteArray>
//#include <QString>
#import "ibuttoncrc.h"

@interface CPacketBuilder : NSObject {
    enum {
        MAX_PACKET_LENGTH = 256,
    };
    int m_idx;
    uint8_t m_data[MAX_PACKET_LENGTH];
    CIButtonCrc *m_crc;
}
-(id)init:(int) command;
-(id)init;
//~CPacketBuilder();
-(void)add8:(int) v;
-(void)add16:(int) v;
-(void)add32:(long) v;
-(void)addFloat:(float) v;
-(int)addString:(NSString*) str :(int) maxSize;
-(NSData*)getPacket;

@end

/*class CPacketBuilder
{
private:
    enum {
        MAX_PACKET_LENGTH = 256,
    };

public:
    CPacketBuilder(int command);
    CPacketBuilder();
    ~CPacketBuilder();

public:
    void add8(int v);
    void add16(int v);
    void add32(long v);
    void addFloat(float v);
    int addString(QString string, int maxSize);
    QByteArray getPacket();

private:
    int m_idx;
    quint8 m_data[MAX_PACKET_LENGTH];
    CIButtonCrc m_crc;
};*/

#endif // PACKETBUILDER_H
