#ifndef PACKETRESPONSE_H
#define PACKETRESPONSE_H

//#include <QtGlobal>
//#include <QByteArray>
//#include <QString>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResponseCode) {
    GENERIC_ERROR,
    OK,
    BUFFER_OVERFLOW,
    CRC_MISMATCH,
    QUERY_OVERFLOW,
    UNSUPPORTED,
    TIMEOUT,
    UNKNOWN,            // Unknown code
    CANCEL,             // Cancel Build
};

@interface CPacketResponse : NSObject {
    int m_rdpos;
    //int m_pllen;
    //uint8_t* m_payload;
}
@property int m_pllen;
@property uint8_t* m_payload;

-(id)init;
-(id)CPacketResponse:(NSData* const) payload;
-(id)init:(uint8_t* const) payload :(int)len;
-(id)init:(CPacketResponse* const) s;
//-(void)CPacketResponse& operator=(const CPacketResponse& s);
//~CPacketResponse();
-(bool)isEmpty;
-(Byte*)getPayload;
-(int)get8;
-(int)get16;
-(int)get32;
-(bool)isOK;
-(ResponseCode)getResponseCode;
-(void)printDebug;

+(ResponseCode)fromInt:(int)value;
+(CPacketResponse*)okResponse;
+(CPacketResponse*)timeoutResponse;

@end


/*class CPacketResponse
{
public:
    enum ResponseCode {
        GENERIC_ERROR,
        OK,
        BUFFER_OVERFLOW,
        CRC_MISMATCH,
        QUERY_OVERFLOW,
        UNSUPPORTED,
        TIMEOUT,
        UNKNOWN,            // Unknown code
        CANCEL,             // Cancel Build
    };

public:
    CPacketResponse();
    CPacketResponse(const QByteArray& payload);
    CPacketResponse(const quint8* payload, int len);
    CPacketResponse(const CPacketResponse& s);
    CPacketResponse& operator=(const CPacketResponse& s);
    ~CPacketResponse();

public:
    bool isEmpty();
    QByteArray getPayload();
    int get8();
    int get16();
    int get32();
    bool isOK();
    ResponseCode getResponseCode();
    void printDebug();

public:
    static ResponseCode fromInt(int value);
    static CPacketResponse okResponse();
    static CPacketResponse timeoutResponse();

private:
    int m_rdpos;
    int m_pllen;
    quint8* m_payload;
};*/

#endif // PACKETRESPONSE_H
