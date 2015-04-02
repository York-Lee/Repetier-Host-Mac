#import "x3gstreamprocess.h"
#import "serial.h"
//#include "tools.h"
//#include <QDebug>

CPacketResponse* runcommandtool(ORSSerialPort* const pcom, CPacketBuilder * const pb, int ms )
{
    if (!pb) {
        return [CPacketResponse timeoutResponse];
    }
    if (ms <= 0) {
        return [CPacketResponse timeoutResponse];
    }
    if (!pcom) {
        return [CPacketResponse timeoutResponse];
    }
    /*if (![pcom isOpen]) {
        return [CPacketResponse timeoutResponse];
    }*/
    /*if ( !pb || ms <= 0 || !pcom || ![pcom isOpen] )
        return [CPacketResponse timeoutResponse];*/

    int i, len, packlen, accupos;
    bool complete = false;
    CPacketProcessor *pp = [[CPacketProcessor alloc] init];
    NSData* ba1;
    uint8_t buff[100];
    [receivePortData setString:@""];
    ba1 = [pb getPacket];

    /****Test****/
    [pcom close];
    serial::Serial serial_com;
    serial::Timeout to = serial::Timeout::simpleTimeout(500);
    std::string name = "/dev/tty.usbmodem1451";
    serial_com.setPort(name);
    serial_com.setBaudrate(115200);
    serial_com.setTimeout(to);
    serial_com.open();
    /*Byte *data_bytes = (Byte*)[ba1 bytes];
    uint8_t* uint_data;// = (uint8_t*)[ba1 bytes];
    for (i = 0; i < [ba1 length]; i++) {
        uint_data[i] = data_bytes[1];
    }
    NSLog(@"data_bytes:%lu, NSLen:%lu", sizeof(data_bytes), [ba1 length]);
    len = (int)serial_com.write(uint_data, [ba1 length]);*/
    len = (int)serial_com.write((uint8_t*)[ba1 bytes], [ba1 length]);
    NSLog(@"Sent length: %d", len);
    
    for ( i = accupos = 0; i < 2 && accupos < 2; i++ ) {
        len = (int)serial_com.read(buff+accupos, 2-accupos);
        accupos += len;
        NSLog(@"len:%d, accupos:%d", len, accupos);
        for (int j = 0; j < accupos; j++) {
            NSLog(@"buff:%d", buff[j]);
        }
    }
    if ( 2 != accupos )
        return [CPacketResponse timeoutResponse];
    
    packlen = buff[1] + 3;
    
    // read payload and checksum
    for ( i = 0; i < ms && accupos < packlen; i++ ) {
        len = (int)serial_com.read(buff+accupos, packlen-accupos);
        accupos += len;
        for (int j = 0; j < accupos; j++) {
            NSLog(@"buff:%d", buff[j]);
        }
    }
    if ( packlen != accupos )
        return [CPacketResponse timeoutResponse];
    
    for ( i = 0; i < packlen; i++ ) {
        assert( false == complete );
        uint8_t u8 = (uint8_t)buff[i];
        complete = [pp processByte:u8];
    }
    serial_com.close();
    /****EndTest****/
    
    /*NSLog(@"%@", ba1);
    bool res = [pcom sendData:ba1];
    NSLog(@"Send Res: %d", res);
    //assert( len == [ba1 length] );

    [NSThread sleepForTimeInterval:1];
    NSLog(@"receivePortData: %@", receivePortData);
    if ([receivePortData length] < 2)
    {
        return [CPacketResponse timeoutResponse];
    }
    buff[0] = [receivePortData characterAtIndex:0];
    buff[1] = [receivePortData characterAtIndex:1];
    accupos = 2;
    
    packlen = buff[1] + 3;
    
    // read payload and checksum
    for ( i = 0; i < ms && accupos < packlen; i++ ) {
        len = 1;
        buff[accupos] = [receivePortData characterAtIndex:accupos];
        //len = pcom->read(buff+accupos, packlen-accupos);
        accupos += len;
    }
    receivePortData = [NSMutableString stringWithString:[receivePortData substringFromIndex:accupos]];*/
    
    // read first two bytes:<0xd5 payloadlength>
    /*for ( i = accupos = 0; i < 2 && accupos < 2; i++ ) {
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
    }*/

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
    //receivePortData = [[NSMutableString alloc] initWithString:@""];
    [m_tmr1 setinterval:500];
    [m_tmr2 setinterval:200];
    return self;
}

-(id)init:(ORSSerialPort*)pCom :(CX3gStreamParser**) pParser
{
    m_brunning = false;
    m_biscomconn = false;
    m_botstate = BUILD_STAT_NONE;
    m_com = NULL; m_x3gsp = NULL;
    //receivePortData = [[NSMutableString alloc] initWithString:@""];
    //initial(pCom, pParser);
    m_com = pCom;
    m_x3gsp = *pParser;
    [m_tmr1 setinterval:500];
    [m_tmr2 setinterval:200];
    receivePortData = [[NSMutableString alloc] initWithString:@""];
    return self;
}

-(void)setupinit:(ORSSerialPort*)pCom :(CX3gStreamParser**) pParser
{
    m_brunning = false;
    m_biscomconn = false;
    m_botstate = BUILD_STAT_NONE;
    m_com = NULL; m_x3gsp = NULL;
    //receivePortData = [[NSMutableString alloc] initWithString:@""];
    //initial(pCom, pParser);
    m_com = pCom;
    m_x3gsp = *pParser;
    [m_tmr1 setinterval:500];
    [m_tmr2 setinterval:200];
}

- (void)serialPort:(ORSSerialPort*)serialPort didReceiveData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([string length] == 0) return;
    [receivePortData appendString:string];
    //[self.receivedDataTextView.textStorage.mutableString appendString:string];
    //[self.receivedDataTextView setNeedsDisplay:YES];
}

//X3gStreamInterface::~X3gStreamInterface() {}

-(void)initial:(ORSSerialPort*) pCom :(CX3gStreamParser*) pParser
{
    assert( pCom && pParser && ![self isExecuting] );
    if ( m_x3gsp && [m_x3gsp isopen] ) {
        NSLog(@"warning: file is already open.");
        assert(0);
    }
    m_com = pCom;
    m_x3gsp = pParser;
}

-(NSString*)getbaudrate
{
    return (NSString*)m_com.baudRate;
}

-(void)setrunflag:(bool) brun
{
    m_brunning = brun;
}

-(CPacketResponse*)runcommand_lock:(CPacketBuilder* const) pb :(int) ms
{
    CPacketResponse *pr;
    [m_mutex lock];
    pr = runcommandtool(m_com, pb, ms);
    [m_mutex unlock];
    return pr;
}

-(bool)startbuild
{
    NSLog(@"parser: %d", [m_x3gsp isopen]);
    NSLog(@"baudRate:%@, isopen:%d", m_com.baudRate, [m_com isOpen]);
    //assert( ![self isExecuting] && m_botstate != BUILD_STAT_RUNNING && m_botstate != BUILD_STAT_CANNELLING );
    m_botstate = BUILD_STAT_NONE;
    //[self run];
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:m_com];
    return true;
}

-(void)pausebuild
{
    m_botstate =
            (BUILD_STAT_RUNNING == m_botstate) ?
                BUILD_STAT_PAUSED : BUILD_STAT_RUNNING;
    //emit this->setbotstat(m_botstate);
    [self performSelectorOnMainThread:@selector(slotbotstateupdate:) withObject:(id)m_botstate waitUntilDone:true];

    CPacketBuilder *pb = [[CPacketBuilder alloc] init:PAUSE];//(MotherboardCommandCode::PAUSE);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :10]];//runcommand_lock(&pb, 10);
    ResponseCode rc = [pr getResponseCode];
    NSLog(@"pausebuild(), response code:%lu", (unsigned long)rc);
}

-(void)cancelbuild
{
    m_botstate = BUILD_STAT_CANCELED;   // set local state first
    //emit this->setbotstat(m_botstate);
    [self performSelectorOnMainThread:@selector(slotbotstateupdate:) withObject:(id)m_botstate waitUntilDone:true];

    CPacketBuilder *pb = [[CPacketBuilder alloc] init:ABORT];//(MotherboardCommandCode::ABORT);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :10]];//runcommand_lock(&pb, 10);
    ResponseCode rc = [pr getResponseCode];
    NSLog(@"cancelbuild(), response code:%lu", (unsigned long)rc);
}

-(void)resetbot
{
    [self readtoclear:5];
    CPacketBuilder *pb = [[CPacketBuilder alloc] init:RESET];//(MotherboardCommandCode::RESET);
    CPacketResponse *pr = [[CPacketResponse alloc] init:[self runcommand_lock:pb :5]];//runcommand_lock(&pb, 5);
    ResponseCode rc = [pr getResponseCode];
    NSLog(@"resetbot(), response code:%lu", (unsigned long)rc);

    // TODO:build state can not get from bot,
    // bot state can not set to NONE from CANCELLED
    /*sleep(1); readtoclear(5);
    BotBuildStat bbs = updatebotstate();
    qDebug("resetbot(), bot state:%d", bbs);*/
    m_botstate = BUILD_STAT_NONE;
}

-(void)run:(ORSSerialPort*) connection_com
{
    NSLog(@"Start Run");
    NSLog(@"%@", [m_x3gsp getfile]);
    [m_x3gsp open:[m_x3gsp getfile]];
    NSLog(@"%@", connection_com.baudRate);
    [connection_com open];
    
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
    //[self performSelectorOnMainThread:@selector(slotbotstateupdate:) withObject:(id)m_botstate waitUntilDone:true];
    assert( [m_x3gsp isopen] );
    //NSLog(@"FileOpen: %d", [m_x3gsp testfile]);

    while ( m_brunning /*&& !m_cancelbuild*/ )
    {
        NSLog(@"Looping Status: %lu, IterationNum: %ld", m_botstate, execcnt);
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
                    NSLog(@"pb is null");
                    m_botstate = BUILD_STAT_FINISHED_NORMALLY;
                    //emit this->setbotstat(m_botstate);
                    //[self performSelectorOnMainThread:@selector(slotbotstateupdate:) withObject:(id)m_botstate waitUntilDone:true];
                    break;
                }

                botfull = false;
                pr = runcommandtool(connection_com, pb, 10);
                ResponseCode rc = [pr getResponseCode];
                switch ( rc ) {
                case OK:
                    [pb dealloc];/*delete pb;*/
                    pb = NULL;
                    execcnt++;
                    break;

                case BUFFER_OVERFLOW:
                    botfull = true;
                    break;

                case CANCEL:       // cancel operation
                    NSLog(@"response: cancel operation.");
                    //m_botstate = BUILD_STAT_CANCELED;
                    [pb dealloc];/*delete pb;*/ pb = NULL;
                    break;

                default:
                    // TODO: on exception, we should stop bot
                    NSLog(@"ERROR: response code:%lu", rc);
                    [pb dealloc];/*delete pb;*/ pb = NULL;
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
                //[self performSelectorOnMainThread:@selector(setbotpercent:) withObject:(id)execcnt waitUntilDone:true];
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
    NSLog(@"thread exit, bbs=%lu", (unsigned long)bbs);
    if ( pb ) [pb dealloc];/*delete pb;*/ pb = NULL;
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
        NSLog(@"updatebotstate() timeout");
        break;

    default:
        NSLog(@"updatebotstate() fail. response code:%lu", (unsigned long)rc);
        break;
    }

    return (BotBuildStat)[pr get8];
}

-(int)readtoclear:(int) retry /*= 50*/
{
    receivePortData = [NSMutableString stringWithString:@""];
    return 0;
    /*if ( !m_com || ![m_com isOpen] )
        return 0;

    int count = 0;
    uint8_t buff[100];

    [m_mutex lock];
    for ( int i = 0; i < retry; i++ ) {
        int len = m_com->read(buff, 10);
        count += len;
    }
    [m_mutex unlock];

    return count;*/
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
        NSLog(@"bot finished:%d", ival);
        return (ival != 0);

    default:
        return false;
    }
}

@end

NSMutableString *receivePortData;