#ifndef TOOLS_H
#define TOOLS_H

//#include <QString>
//#include <QByteArray>
#import <Foundation/Foundation.h>

NSData* str2hex(NSString* const str);
NSString* hexarr2str(const NSData* cstr, bool bseprator);
unsigned short qchar2value(Byte ch);

@interface CUserTimer : NSObject {
    double m_interval;
    double m_tmrstart;
    double m_tmrcurrent;
}
-(void)CUserTimer;
-(void)CUserTimer:(double) intervalms;
//~CUserTimer();
-(void)reset;
-(void)setinterval:(double) intervalms;
-(bool)timerellapsed;
@end

/*class CUserTimer
{
public:
    CUserTimer();
    CUserTimer(double intervalms);
    ~CUserTimer();

public:
    void reset();
    void setinterval(double intervalms);
    bool timerellapsed();

private:
    double m_interval;
    double m_tmrstart;
    double m_tmrcurrent;
};*/

#endif // TOOLS_H
