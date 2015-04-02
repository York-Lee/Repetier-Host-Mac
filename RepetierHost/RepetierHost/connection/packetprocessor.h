#ifndef PACKETPROCESSOR_H
#define PACKETPROCESSOR_H

//#include <QtGlobal>
//#include <QByteArray>
//#include <QString>
#import "ibuttoncrc.h"
#import "packetresponse.h"


typedef NS_ENUM(NSUInteger, PacketState)
{
    START, LEN, PAYLOAD, CRC, LAST
};

@interface CPacketProcessor : NSObject {
    
    PacketState m_packstat;
    int m_plidx;
    int8_t m_targetcrc;
    CIButtonCrc* m_crc;
    int m_pllen;
    int8_t* m_payload;
}
-(id)init;
//~CPacketProcessor();
-(void)reset;
-(CPacketResponse*)getResponse;
-(BOOL)processByte:(uint8_t) b;

@end

/*class CPacketProcessor
{
private:
    enum PacketState {
        START, LEN, PAYLOAD, CRC, LAST
    };

public:
    CPacketProcessor();
    ~CPacketProcessor();

public:
    void reset();
    CPacketResponse getResponse();
    bool processByte(quint8 b);

private:
    PacketState m_packstat;
    int m_pllen;
    int m_plidx;
    quint8* m_payload;
    quint8 m_targetcrc;
    CIButtonCrc m_crc;
};*/

#endif // PACKETPROCESSOR_H
