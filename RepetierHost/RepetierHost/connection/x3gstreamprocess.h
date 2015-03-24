#ifndef X3GSTREAMPROCESS_H
#define X3GSTREAMPROCESS_H

#include <time.h>
#include <math.h>
//#include <QtGlobal>
//#include <QByteArray>
//#include <QString>
//#include <QThread>
//#include <QQueue>
//#include <QMutex>
#import "tools.h"
#import "packetbuilder.h"
#import "packetresponse.h"
#import "packetprocessor.h"
#import "x3gstreamparser.h"
#import "ORSSerialPort.h"
#import "motherboardcommandcode.h"
//#import "serial.h"
//#include "../serial/include/serial.h"

/*using std::string;
using std::exception;
using std::vector;
typedef QQueue<CPacketResponse> TQPacketResponse;*/

CPacketResponse* runcommandtool(ORSSerialPort* const pcom, CPacketBuilder* const pb, int ms);

typedef NS_ENUM(NSUInteger, BotBuildStat)
{
    BUILD_STAT_NONE,
    BUILD_STAT_RUNNING,
    BUILD_STAT_FINISHED_NORMALLY,
    BUILD_STAT_PAUSED,
    BUILD_STAT_CANCELED,
    BUILD_STAT_CANNELLING,
    BUILD_STAT_MAX
};

@interface X3gStreamInterface : NSObject <ORSSerialPortDelegate>
{
    //Q_OBJECT
    volatile bool m_brunning;
    volatile bool m_biscomconn;
    volatile BotBuildStat m_botstate;
    CUserTimer *m_tmr1, *m_tmr2;
    //ORSSerialPort *m_com;//serial::Serial* m_com;
    ORSSerialPort* m_com;
    CX3gStreamParser* m_x3gsp;
    //NSMutableString *receiveData;
    NSData *m_data;//QByteArray m_data;
    NSLock* m_mutex;// = GetArrayLock();
    //QMutex m_mutex;
    //public:
    /*enum BotBuildStat {
        BUILD_STAT_NONE = 0,
        BUILD_STAT_RUNNING = 1,
        BUILD_STAT_FINISHED_NORMALLY = 2,
        BUILD_STAT_PAUSED = 3,
        BUILD_STAT_CANCELED = 4,
        BUILD_STAT_CANNELLING = 5,
        BUILD_STAT_MAX = 5
    };*/
}

-(id)init;
-(id)init:(ORSSerialPort*) pCom :(CX3gStreamParser**) pParser;
-(void)setupinit:(ORSSerialPort*)pCom :(CX3gStreamParser**) pParser;
//~X3gStreamInterface();

-(void)initial:(ORSSerialPort*) pCom :(CX3gStreamParser*) pParser;
-(void)setrunflag:(bool) brun;
-(CPacketResponse*)runcommand_lock:(CPacketBuilder* const) pb :(int) ms;
-(bool)startbuild;
-(void)pausebuild;
-(void)cancelbuild;
-(void)resetbot;
-(void)run:(ORSSerialPort*) connection_com;
-(void)usrtimerstart;
-(void)usrtimerstop;
-(bool)usrtimerellapse;
-(BotBuildStat)updatebotstate:(int) retry;// = 10);
-(int)readtoclear:(int) retry;// = 50);
-(bool)isbotfinished;
-(NSString*)getbaudrate;

/*signals:
    void setbotstat(int stat);
    void setbotpercent(long execcnt);
};*/

@end

extern NSMutableString *receivePortData;

#endif // X3GSTREAMPROCESS_H
