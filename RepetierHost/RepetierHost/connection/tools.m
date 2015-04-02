#include <math.h>
//#include <QChar>
//#include <QDebug>
#import "tools.h"

@implementation CUserTimer

NSData* str2hex(const NSString* str)
{
    int i, j, len = [str length] / 2;
    Byte* cstr = (Byte*)malloc(len);
    //memcpy(ba, m_payload, m_pllen)
    //Byte* cstr; cstr.resize(len);

    for ( i = 0, j = 0; i < len; i++ ) {
        unsigned short c1 = qchar2value([str characterAtIndex:j]);
        j++;
        unsigned short c2 = qchar2value([str characterAtIndex:j]);
        j++;
        cstr[i] = ((c1 & 0xff) << 4) + (c2 & 0xff);
    }

    NSData* cstr_data = [[NSData alloc] initWithBytes:cstr length:len];
    return cstr_data;
}

NSString* hexarr2str(const NSData* cstr, bool bseprator)
{
    int i;
    NSMutableString *s;
    NSString *s2;
    Byte *cstr_bytes = (Byte *)[cstr bytes];
    if ( false == bseprator ) {
        //s.resize(cstr.length() * 2);
        for ( i = 0; i < [cstr length]; i++ ) {
            //s2.sprintf("%02x", cstr_bytes[i] & 0xff);
            s2 = [NSString stringWithFormat:@"%02x", cstr_bytes[i] & 0xff];
            [s appendString:s2];//s += s2;
        }
    }
    else {
        //s.resize(cstr.length() * 3);
        for ( i = 0; i < [cstr length]; i++ ) {
            //s2.sprintf("%02x ", cstr_bytes[i] & 0xff);
            s2 = [NSString stringWithFormat:@"%02x", cstr_bytes[i] & 0xff];
            [s appendString:s2];;
        }
    }

    //s.trimmed();
    return s;
}

unsigned short qchar2value(Byte ch)
{
    unsigned char c8 = ch;//ch.toLatin1();

    if ( c8 >= '0' && c8 <= '9' )
        return (c8 - '0');
    else if ( c8 >= 'A' && c8 <= 'F' )
        return (c8 - 'A' + 0x0A);
    else if ( c8 >= 'a' && c8 <= 'f' )
        return (c8 - 'a' + 0x0A);

    return 0;
}


-(id)init
{
    m_interval = 0.0;
    m_tmrstart = 0.0;
    m_tmrcurrent = 0.0;
    return self;
}

-(id)init:(double) intervalms
{
    m_tmrstart = 0.0;
    m_tmrcurrent = 0.0;
    [self setinterval:intervalms];
    return self;
}

//CUserTimer::~CUserTimer() {}

-(void)reset
{
    m_tmrstart = (double)clock();
    m_tmrcurrent = m_tmrstart;
}

-(void)setinterval:(double) intervalms
{
    m_interval = fabs(intervalms);
}

-(bool)timerellapsed
{
    m_tmrcurrent = (double)clock();
    if ( fabs(m_tmrcurrent-m_tmrstart) > m_interval ) {
        m_tmrstart = m_tmrcurrent;
        return true;
    }
    return false;
}

@end