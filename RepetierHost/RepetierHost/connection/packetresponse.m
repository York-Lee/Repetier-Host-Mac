#include "packetresponse.h"
//#include <QDebug>

@implementation CPacketResponse
@synthesize m_pllen;
@synthesize m_payload;


-(id)init
{
    m_rdpos = 1;
    m_pllen = 0;
    m_payload = NULL;
    return 0;
}

-(void)CPacketResponse:(NSData* const) payload
{
    m_rdpos = 1;
    m_pllen = 0;
    m_payload = NULL;
    if ( [payload length] > 0 ) {
        m_pllen = [payload length];
        m_payload = (int8_t*)malloc(m_pllen);// new quint8[m_pllen];
        memcpy(m_payload, [payload bytes], m_pllen);
    }
}

-(id)init:(int8_t* const) payload :(int) len
{
    m_rdpos = 1;
    m_pllen = 0;
    m_payload = NULL;
    if ( len > 0 ) {
        m_pllen = len;
        m_payload = (int8_t*)malloc(len);//new quint8[len];
        memcpy(m_payload, payload, len);
    }
    return 0;
}

-(id)init:(CPacketResponse* const) s
{
    m_payload = NULL;
    m_rdpos = s->m_rdpos; m_pllen = s->m_pllen;
    if ( m_pllen > 0 ) {
        m_payload = (int8_t*)malloc(m_pllen);
        memcpy(m_payload, s->m_payload, m_pllen);
    }
    return 0;
}

/*CPacketResponse& CPacketResponse::operator=( const CPacketResponse& s )
{
    if ( NULL != m_payload ) {
        delete[] m_payload;
        m_payload = NULL;
    }

    m_rdpos = s.m_rdpos; m_pllen = s.m_pllen;
    if ( m_pllen > 0 ) {
        m_payload = new quint8[m_pllen];
        memcpy(m_payload, s.m_payload, m_pllen);
    }

    return *this;
}*/

/*CPacketResponse::~CPacketResponse()
{
    if ( NULL != m_payload )
        delete[] m_payload;
}*/

-(bool)isEmpty
{
    return (NULL == m_payload);
}

-(Byte*)getPayload
{
    if ( NULL == m_payload )
        return NULL;

    Byte* ba = (Byte*)malloc(m_pllen);
    memcpy(ba, m_payload, m_pllen);
    return ba;
}

-(int)get8
{
    if ( NULL == m_payload || m_pllen <= m_rdpos ) {
        //qDebug() << "Error: payload null or not big enough.";
        return 0;
    }

    int ival = m_payload[m_rdpos++];
    return (ival & 0xff);
}

-(int)get16
{
    return ([self get8] + ([self get8] << 8));
}

-(int)get32
{
    return ([self get16] + ([self get16] << 16));
}

-(bool)isOK
{
    return ([self getResponseCode] == OK);
}

-(ResponseCode)getResponseCode
{
    if ( NULL != m_payload && m_pllen > 0 )
        return [CPacketResponse fromInt:m_payload[0] & 0xff];
    return GENERIC_ERROR;
}

-(void)printDebug
{
    /*if ( NULL == m_payload ) {
        qDebug() << "CPacketResponse::printDebug error: object null." << "\n";
        return;
    }

    NSString *s1, *s2;
    for ( int i = 0; i < m_pllen; i++ ) {
        s2.sprintf(" %02x", m_payload[i]);
        s1 += s2;
    }
    qDebug() << "payload of packet:" << s1 << "\n";*/
}


+(ResponseCode)fromInt:(int) value
{
    switch( value ) {
    case 0x0:
    case 0x80:
        return GENERIC_ERROR;
    case 0x1:
    case 0x81:
        return OK;
    case 0x2:
    case 0x82:
        return BUFFER_OVERFLOW;
    case 0x3:
    case 0x83:
        return CRC_MISMATCH;
    case 0x4:
    case 0x84:
        return QUERY_OVERFLOW;
    case 0x5:
    case 0x85:
        return UNSUPPORTED;
    case 0x6:
    case 0x86:
        return OK;  // more packets expected?
    case 0x09:
    case 0x89:
        return CANCEL;
    case 127:
        return TIMEOUT;
    }

    return UNKNOWN;
}

+(CPacketResponse*)okResponse
{
    Byte okPayload[] = {1,1,1,1,1,1,1,1};     // repeated 1s to fake out queries
    CPacketResponse *pr = [[CPacketResponse alloc] init:(int8_t*)okPayload :sizeof(okPayload)];//(okPayload, sizeof(okPayload));
    return pr;
}

+(CPacketResponse*)timeoutResponse
{
    int8_t errorPayload[] = {127,0,0,0,0,0,0,0}; // repeated 0s to fake out queries
    CPacketResponse *pr = [[CPacketResponse alloc] init:errorPayload :sizeof(errorPayload)];//(errorPayload, sizeof(errorPayload));
    return pr;
}

@end