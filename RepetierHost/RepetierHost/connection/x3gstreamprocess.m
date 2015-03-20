#import "x3gstreamprocess.h"
//#include "tools.h"
//#include <QDebug>

CPacketResponse* runcommandtool(serial::Serial* const pcom, CPacketBuilder * const pb, int ms, NSMutableString *receiveData )
{
    if ( !pb || ms <= 0 || !pcom || !pcom->isOpen() )
        return [CPacketResponse timeoutResponse];

    int i, len, packlen, accupos;
    bool complete = false;
    CPacketProcessor *pp;
    NSData* ba1;
    uint8_t buff[100];

    //[receiveData setString:@""];
    ba1 = [pb getPacket];
    len = pcom->write((uint8_t*)[ba1 bytes], [ba1 length]);
    assert( len == [ba1 length] );

    /*[NSThread sleepForTimeInterval:1];
    if ([receiveData length] < 2)
    {
        return [CPacketResponse timeoutResponse];
    }
    buff[0] = [receiveData characterAtIndex:0];
    buff[1] = [receiveData characterAtIndex:1];
    accupos = 2;
    
    packlen = buff[1] + 3;
    
    // read payload and checksum
    for ( i = 0; i < ms && accupos < packlen; i++ ) {
        len = 1;
        buff[accupos] = [receiveData characterAtIndex:accupos];
        //len = pcom->read(buff+accupos, packlen-accupos);
        accupos += len;
    }
    [receiveData setString:@""];*/
    // read first two bytes:<0xd5 payloadlength>
    for ( i = accupos = 0; i < 2 && accupos < 2; i++ ) {
        len = pcom->read(buff+accupos, 2-accupos);
        accupos += len;
    }
    if ( 2 != accupos )
        return [CPacketResponse timeoutResponse];

    packlen = buff[1] + 3;

    // read payload and checksum
    for ( i = 0; i < ms && accupos < packlen; i++ ) {
        len = pcom->read(buff+accupos, packlen-accupos);
        accupos += len;
    }
    if ( packlen != accupos )
        return [CPacketResponse timeoutResponse];

    for ( i = 0; i < packlen; i++ ) {
        assert( false == complete );
        int8_t u8 = (int8_t)buff[i];
        complete = [pp processByte:u8];
    }

    //if ( complete ) {
    //    QByteArray ba; ba.resize(packlen);
    //    memcpy(ba.data(), buff, packlen);
    //    QString s = hexarr2str(ba, false);
    //    qDebug() << s;
    //}

    if ( complete ) {
        assert( i == packlen );
        return [pp getResponse];
    }

    return [CPacketResponse timeoutResponse];
}

@implementation X3gStreamInterface

-(id)init
{
    m_brunning = false;
    m_biscomconn = false;
    m_botstate = BUILD_STAT_NONE;
    m_com = NULL; m_x3gsp = NULL;
    receiveData = [NSMutableString init];
    [m_tmr1 setinterval:500];
    [m_tmr2 setinterval:200];
    return 0;
}

-(id)init:(serial::Serial*)pCom :(CX3gStreamParser*) pParser
{
    m_brunning = false;
    m_biscomconn = false;
    m_botstate = BUILD_STAT_NONE;
    m_com = NULL; m_x3gsp = NULL;
    receiveData = [NSMutableString init];
    //initial(pCom, pParser);
    m_com = pCom;
    m_x3gsp = pParser;
    [m_tmr1 setinterval:500];
    [m_tmr2 setinterval:200];
    return 0;
}

- (void)serialPort:(serial::Serial*)serialPort didReceiveData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([string length] == 0) return;
    [receiveData appendString:string];
    //[self.receivedDataTextView.textStorage.mutableString appendString:string];
    //[self.receivedDataTextView setNeedsDisplay:YES];
}

//X3gStreamInterface::~X3gStreamInterface() {}

-(void)initial:(serial::Serial*) pCom :(CX3gStreamParser*) pParser
{
    assert( pCom && pParser && ![self isExecuting] );
    if ( m_x3gsp && [m_x3gsp isopen] ) {
        //qDebug("warning: file is already open.");
        assert(0);
    }
    m_com = pCom;
    m_x3gsp = pParser;
}

-(void)setrunflag:(bool) brun
{
    m_brunning = brun;
}

-(CPacketResponse*)runcommand_lock:(CPacketBuilder* const) pb :(int) ms
{
    CPacketResponse *pr;
    [m_mutex lock];
    pr = runcommandtool(m_com, pb, ms, receiveData);
    [m_mutex unlock];
    return pr;
}

-(bool)startbuild
{
    assert( ![self isExecuting] &&
              m_botstate != BUILD_STAT_RUNNING &&
              m_botstate != BUILD_STAT_CANNELLING );
    m_botstate = BUILD_STAT_NONE;
    return true;
}

-(void)pausebuild
{
    m_botstate =
            (BUILD_STAT_RUNNING == m_botstate) ?
                BUILD_STAT_PAUSED : BUILD_STAT_RUNNING;
    //emit this->setbotstat(m_botstate);

    CPacketBuilder *pb = [[CPacketBuilder alloc] init:PAUSE];//(MotherboardCommandCode::PAUSE);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :10]];//runcommand_lock(&pb, 10);
    ResponseCode rc = [pr getResponseCode];
    //qDebug("pausebuild(), response code:%d", rc);
}

-(void)cancelbuild
{
    m_botstate = BUILD_STAT_CANCELED;   // set local state first
    //emit this->setbotstat(m_botstate);

    CPacketBuilder *pb = [[CPacketBuilder alloc] init:ABORT];//(MotherboardCommandCode::ABORT);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :10]];//runcommand_lock(&pb, 10);
    ResponseCode rc = [pr getResponseCode];
    //qDebug("cancelbuild(), response code:%d", rc);
}

-(void)resetbot
{
    [self readtoclear:5];
    CPacketBuilder *pb = [[CPacketBuilder alloc] init:RESET];//(MotherboardCommandCode::RESET);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :5]];//runcommand_lock(&pb, 5);
    ResponseCode rc = [pr getResponseCode];
    //qDebug("resetbot(), response code:%d", rc);

    // TODO:build state can not get from bot,
    // bot state can not set to NONE from CANCELLED
    /*sleep(1); readtoclear(5);
    BotBuildStat bbs = updatebotstate();
    qDebug("resetbot(), bot state:%d", bbs);*/
    m_botstate = BUILD_STAT_NONE;
}

-(void)run
{
    long execcnt = 0;
    bool botfull = false;
    CPacketBuilder* pb = NULL;
    CPacketResponse *pr;

    m_biscomconn = true;    // on start, we assume connection is established
    [m_tmr1 reset];
    [m_tmr2 reset];

    // force to set build state to running
    // and generate an event to notify state changed
    m_botstate = BUILD_STAT_RUNNING;
    //emit this->setbotstat(m_botstate);
    assert( [m_x3gsp isopen] );

    while ( m_brunning /*&& !m_cancelbuild*/ )
    {
        // lock all switch-case
        // structure to avoid sending command
        // just after cancel command from main thread.
        [m_mutex lock];

        switch ( m_botstate )
        {
        case BUILD_STAT_PAUSED:
        case BUILD_STAT_CANNELLING:
        case BUILD_STAT_CANCELED:
        case BUILD_STAT_FINISHED_NORMALLY:
            break;

        case BUILD_STAT_NONE:
        case BUILD_STAT_RUNNING:
            {
                if ( ![m_x3gsp isopen] ) break;
                if ( !botfull ) pb = [m_x3gsp getnext];

                // all x3g send done, wait for bot stop
                if ( NULL == pb ) {
                    m_botstate = BUILD_STAT_FINISHED_NORMALLY;
                    //emit this->setbotstat(m_botstate);
                    break;
                }

                botfull = false;
                pr = runcommandtool(m_com, pb, 10, receiveData);
                ResponseCode rc = [pr getResponseCode];
                switch ( rc ) {
                case OK:
                    /*delete pb;*/
                    pb = NULL;
                    execcnt++;
                    break;

                case BUFFER_OVERFLOW:
                    botfull = true;
                    break;

                case CANCEL:       // cancel operation
                    //qDebug("response: cancel operation.");
                    //m_botstate = BUILD_STAT_CANCELED;
                    /*delete pb;*/ pb = NULL;
                    break;

                default:
                    // TODO: on exception, we should stop bot
                    //qDebug("ERROR: response code:%d", rc);
                    /*delete pb;*/ pb = NULL;
                    execcnt++;
                    break;
                }
            }
            break;

        default:
            assert(0);
            break;
        }

        [m_mutex unlock];

        // timer task: update bot state
        if ( [m_tmr1 timerellapsed] )
        {
            // TODO: there's no state transform CALCEN->NONE
            /*BotBuildStat bbs = updatebotstate();
            if ( m_botstate != bbs ) {
                m_botstate = bbs;
                emit this->setbotstat((int)bbs);
            }*/

            if ( BUILD_STAT_RUNNING == m_botstate ) {
                //emit this->setbotpercent(execcnt);
            }
        }

        // timer task: checking if bot stop
        /*if ( m_tmr2.timerellapsed() ) {
            if ( m_bcancelbuild && isbotfinished() ) {
                CPacketBuilder pb(MotherboardCommandCode::ABORT);
                CPacketResponse pr = runcommand(&pb, 10);
                CPacketResponse::ResponseCode rc = pr.getResponseCode();
                m_bcancelbuild = false;
                m_botstate = BUILD_STAT_CANCELED;
                emit this->setbotstat(m_botstate);
            }
        }*/
    }

    BotBuildStat bbs = [self updatebotstate:10];
    //qDebug("thread exit, bbs=%d", bbs);
    if ( pb ) /*delete pb;*/ pb = NULL;
}

-(BotBuildStat)updatebotstate:(int) retry /*=10*/
{
    CPacketBuilder *pb = [[CPacketBuilder alloc] init:GET_BUILD_STAT];//(MotherboardCommandCode::GET_BUILD_STAT);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :retry]];//runcommand_lock(&pb, retry);
    ResponseCode rc = [pr getResponseCode];
    switch ( rc ) {
    case OK:
    case CANCEL:
        break;

    case TIMEOUT:
        //qDebug("updatebotstate() timeout");
        break;

    default:
        //qDebug("updatebotstate() fail. response code:%d", rc);
        break;
    }

    return (BotBuildStat)[pr get8];
}

-(int)readtoclear:(int) retry /*= 50*/
{
    if ( !m_com || !m_com->isOpen() )
        return 0;

    int count = 0;
    uint8_t buff[100];

    [m_mutex lock];
    for ( int i = 0; i < retry; i++ ) {
        int len = m_com->read(buff, 10);
        count += len;
    }
    [m_mutex unlock];

    return count;
}

-(bool)isbotfinished
{
    int ival;
    CPacketBuilder *pb = [[CPacketBuilder alloc] init:IS_FINISHED];//(MotherboardCommandCode::IS_FINISHED);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :10]];//runcommand_lock(&pb, 10);
    ResponseCode rc = [pr getResponseCode];
    switch ( rc ) {
    case OK:
    case CANCEL:
        ival = [pr get8];
        //qDebug("bot finished:%d", ival);
        return (ival != 0);

    default:
        return false;
    }
}

@end

