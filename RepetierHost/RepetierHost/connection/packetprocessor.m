#include "packetprocessor.h"
#include "packetconstants.h"

@implementation CPacketProcessor

-(id)init
{
    m_packstat = START;
    m_pllen = -1;
    m_plidx = 0;
    m_payload = NULL;
    m_targetcrc = 0;
    return self;
}

/*CPacketProcessor::~CPacketProcessor()
{
    if ( NULL != m_payload )
        delete[] m_payload;
}*/

-(void)reset
{
    m_packstat = START;
    if ( m_payload ) {
        //delete[] m_payload;
        m_payload = NULL;
    }

    [m_crc reset];
    m_pllen = -1; m_plidx = 0;
    m_targetcrc = 0;
}

-(CPacketResponse*)getResponse
{
    if ( m_pllen <= 0 ) {
        CPacketResponse* pr;
        return pr;
    }

    assert(m_payload && m_pllen > 0);
    CPacketResponse* pr;//(m_payload, m_pllen);
    pr.m_payload = m_payload;
    return pr;
}

-(BOOL)processByte:(uint8_t) b
{
    /*if ( b >= 32 && b <= 127 ) {
        qDebug("IN: Processing byte %02x(%c)", b, b);
    } else {
        qDebug("IN: Processing byte %02x", b);
    }*/

    switch ( m_packstat )
    {
    case START:
        if ( b == START_BYTE ) {
            m_packstat = LEN;
        } else {
            // throw exception?
            assert(0);
        }
        break;

    case LEN:
        NSLog(@"Length: %d", b);
        m_pllen = ((int)b) & 0xFF;
        m_payload = (int8_t*)(m_pllen);
        [m_crc reset];
        m_packstat = (m_pllen > 0) ? PAYLOAD : CRC;
        break;

    case PAYLOAD:
        // sanity check
        if ( m_plidx < m_pllen ) {
            m_payload[m_plidx++] = b;
            [m_crc update:(b)];
        }
        if ( m_plidx >= m_pllen )
            m_packstat = CRC;
        break;

    case CRC:
        m_targetcrc = b;
        //NSLog(@"Target CRC: %02x - expected CRC: %02x", m_targetcrc, m_crc.getcrc());
        if ([m_crc getcrc] != m_targetcrc ) {
            assert(0);
            return false;
        }
        return true;

    default:
        break;
    }

    return false;
}

@end
