//#include <QDebug>
//#include <QTime>
#import "x3gstreamparser.h"

//static const int m_buffsize;
//static const int m_bufflentoparse;

@implementation S3gCmdFormat

-(id)init
{
    assert(0);
    return 0;
}

-(id)init:(S3gCmdFormat* const) val
{
    m_cmd = val->m_cmd; m_parlen = val->m_parlen;
    m_subcmd = val->m_subcmd; m_subcmdpos = val->m_subcmdpos;
    m_bparstring = val->m_bparstring;
    return 0;
}

-(id)init:(int)Cmd :(int)Parlen :(int)Subcmd :(int)SubcmdPos :(bool)HasString
{
    m_cmd = Cmd; m_parlen = Parlen;
    m_subcmd = Subcmd; m_subcmdpos = SubcmdPos;
    m_bparstring = HasString;
    return 0;
}

//S3gCmdFormat::~S3gCmdFormat(){}

-(CPacketBuilder*)tryparse:(int8_t*) stream :(int) pos1 :(int) pos2 :(int*) nextpos
{
    *nextpos = pos1;

    if ( (pos1+m_parlen+1) > pos2 || stream[pos1] != m_cmd ) return NULL;
    if ( m_subcmd >= 0 && m_subcmd != stream[pos1+m_subcmdpos] ) return NULL;

    int i = pos1 + 1;
    *nextpos = i + m_parlen;
    CPacketBuilder* pb = [[CPacketBuilder alloc] init:m_cmd];//new CPacketBuilder((MotherboardCommandCode::MotherboardCommandCode)m_cmd);
    for ( ; i < *nextpos; i++ )
        [pb add8:stream[i]];

    if ( true == m_bparstring ) {
        while ( *nextpos < pos2 && 0 != stream[*nextpos] ) (*nextpos)++;
        if ( *nextpos >= pos2 ) {
            /*delete pb;*/ pb = NULL;
            return NULL;
        }

        (*nextpos)++;
        for ( ; i < *nextpos; i++ )
            [pb add8:stream[i]];
    }

    return pb;
}

@end

@implementation CX3gStreamParser

typedef struct _TPattenList {
    int cmd, parlen, subcmd, subcmdpos;
    bool hasstring;
} TPattenList;

static TPattenList glstPatten[] = {
    {0, 2, -1, -1, false},
    {1, 0, -1, -1, false},
    {4, 0, -1, -1, false},
    {7, 0, -1, -1, false},
    {8, 0, -1, -1, false},
    {11, 0, -1, -1, false},
    {12, 3, -1, -1, false},
    {13, 3, -1, -1, false},
    {14, 0, -1, -1, true},
    {15, 0, -1, -1, false},
    {16, 0, -1, -1, true},
    {17, 0, -1, -1, false},
    {18, 1, -1, -1, false},
    {20, 2, -1, -1, false},
    {21, 0, -1, -1, false},
    {22, 1, -1, -1, false},
    {153, 4, -1, -1, true},
    {154, 1, -1, -1, false},
    {155, 31, -1, -1, false},
    {156, 1, -1, -1, false},
    {25, 0, -1, -1, false},
    {129, 16, -1, -1, false},
    {130, 12, -1, -1, false},
    {131, 7, -1, -1, false},
    {132, 7, -1, -1, false},
    {133, 4, -1, -1, false},
    {134, 1, -1, -1, false},
    {135, 5, -1, -1, false},
    {137, 1, -1, -1, false},
    {139, 24, -1, -1, false},
    {140, 20, -1, -1, false},
    {141, 5, -1, -1, false},
    {142, 25, -1, -1, false},
    {143, 1, -1, -1, false},
    {144, 1, -1, -1, false},
    {145, 2, -1, -1, false},
    {146, 5, -1, -1, false},
    {147, 5, -1, -1, false},
    {148, 4, -1, -1, false},
    {149, 4, -1, -1, true},
    {150, 2, -1, -1, false},
    {151, 1, -1, -1, false},
    {152, 1, -1, -1, false},
    {10, 2, 0, 2, false},
    {10, 2, 2, 2, false},
    {10, 2, 17, 2, false},
    {10, 2, 18, 2, false},
    {10, 2, 19, 2, false},
    {10, 2, 20, 2, false},
    {10, 5, 25, 2, false},
    {10, 5, 26, 2, false},
    {10, 4, 27, 2, false},
    {10, 2, 30, 2, false},
    {10, 2, 32, 2, false},
    {10, 2, 33, 2, false},
    {10, 2, 34, 2, false},
    {10, 2, 36, 2, false},
    {10, 2, 37, 2, false},
    {136, 5, 3, 2, false},
    {136, 4, 4, 2, false},
    {136, 4, 5, 2, false},
    {136, 7, 6, 2, false},
    {136, 7, 7, 2, false},
    {136, 4, 10, 2, false},
    {136, 4, 11, 2, false},
    {136, 4, 12, 2, false},
    {136, 4, 13, 2, false},
    {136, 4, 14, 2, false},
    {136, 4, 15, 2, false},
    {136, 5, 31, 2, false},
    {157, 20, -1, -1, false}    // new added command
};

#define PATTENLIST_LENGTH   ((int)(sizeof(glstPatten) / sizeof(TPattenList)))


static const int m_buffsize = 1024 * 64;
static const int m_bufflentoparse = 1024;

-(void)CX3gStreamParser
{
    m_buffpos = 0; m_bufflen = 0;
    m_buffer = (int8_t*)malloc(m_buffsize);//new quint8[m_buffsize];

    S3gCmdFormat* ps3g;
    for ( int i = 0; i < PATTENLIST_LENGTH; i++ ) {
        ps3g = [[S3gCmdFormat alloc] init:glstPatten[i].cmd :glstPatten[i].parlen :glstPatten[i].subcmd :glstPatten[i].subcmdpos :glstPatten[i].hasstring];//new S3gCmdFormat(glstPatten[i].cmd, glstPatten[i].parlen, glstPatten[i].subcmd, glstPatten[i].subcmdpos, glstPatten[i].hasstring);
        [m_pattens addObject:ps3g];//.append(ps3g);
    }

    m_cmdstatistic = (int*)malloc(PATTENLIST_LENGTH);//new int[PATTENLIST_LENGTH];
    [self statisticreset];
}

/*CX3gStreamParser::~CX3gStreamParser()
{
    Q_ASSERT(m_buffer);
    delete[] m_buffer;
    if ( m_file.isOpen() )
        m_file.close();

    delete[] m_cmdstatistic;
    for ( int i = 0; i < m_pattens.count(); i++ ) {
        delete m_pattens.at(i);
        m_pattens.replace(i, NULL);
    }
}*/

-(bool)open:(NSString*) strFile
{
    /*if ( m_file.isOpen() ) m_file.close();

    m_buffpos = 0; m_bufflen = 0;
    m_file.setFileName(strFile);
    bool berr = m_file.open(QIODevice::ReadOnly);
    if ( false == berr ) {
        //qDebug() << "CX3gStreamParser::open() fail. file: " << strFile << "\n";
        return false;
    }

    return true;*/
    m_file = strFile;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:m_file])
    {
        fileHandle = [NSFileHandle fileHandleForReadingAtPath:m_file];
    }
    return true;
}

-(bool)isopen
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if (![filemgr fileExistsAtPath:m_file]) return false;
    else return true;
    //return m_file.isOpen();
}

-(void)close
{
    /*if ( m_file.isOpen() )
        m_file.close();*/
    [fileHandle closeFile];
    m_buffpos = 0;
    m_bufflen = 0;
}

-(void)statisticreset
{
    assert( m_cmdstatistic );
    memset(m_cmdstatistic, 0, sizeof(int) * PATTENLIST_LENGTH);
}

-(void)statisticdbgprint
{
    for ( int i = 0; i < PATTENLIST_LENGTH; i++ ) {
        //qDebug("command:%02x, statistic:%d", glstPatten[i].cmd, m_cmdstatistic[i]);
    }
}

-(CPacketBuilder*)getnext
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if (![filemgr fileExistsAtPath:m_file]) return NULL;
    //if ( false == m_file.isOpen() ) return NULL;
    /*if ( m_file.atEnd() && m_bufflen <= 0 ) {
        //qDebug("S3gParser--end of file<%d, %d, %lld>", m_buffpos, m_bufflen, m_file.pos());
        return NULL;
    }*/

    // make sure there's enouth space for file read
    int temp = m_buffsize - m_bufflen - m_buffpos;
    if ( temp <= m_bufflentoparse && m_bufflen < m_bufflentoparse ) {
        memcpy(m_buffer, m_buffer+m_buffpos, m_bufflen);
        m_buffpos = 0;
    }

    // make sure there's enouth data for parsing
    if ( m_bufflen < m_bufflentoparse ) {
        int pos = m_buffpos + m_bufflen;
        NSData * dataread = [fileHandle readDataOfLength:m_buffsize-pos];
        int cnt = [dataread length];
        char* m_buffer_tmp = (char*)(m_buffer + pos);
        m_buffer_tmp = (char*)[dataread bytes];
        //int cnt = m_file.read((char*)(m_buffer+pos), m_buffsize-pos);
        m_bufflen += cnt;
    }

    int i, *nextpos = 0;
    CPacketBuilder* pb = NULL;
    for ( i = 0; i < [m_pattens count]; i++ ) {
        pb = [(S3gCmdFormat*)[m_pattens objectAtIndex:i] tryparse:m_buffer :m_buffpos :m_buffpos+m_bufflen :nextpos]; //tryparse(m_buffer, m_buffpos, m_buffpos + m_bufflen, nextpos)];
        if ( NULL != pb ) {
            m_cmdstatistic[i]++;
            break;
        }
    }

    if ( NULL == pb ) {
        //qDebug("pb null. <%d, %d, %lld>:", m_buffpos, m_bufflen, m_file.pos());
        assert(0);
        return NULL;
    }

    assert( *nextpos > m_buffpos && *nextpos <= m_buffsize );
    m_bufflen -= *nextpos - m_buffpos;
    m_buffpos = *nextpos;
    return pb;
}

+(int)getcount:(NSString*) strfile
{
    CX3gStreamParser *x3gsp;
    [x3gsp open:strfile];
    if ( [x3gsp isopen] ) {
        //qDebug("getcount--open file fail.");
        return 0;
    }

    NSDate *start = [NSDate date];
    //QTime tm1;
    //tm1.start();

    int count = 0;
    CPacketBuilder* pb = NULL;
    while ( 1 ) {
        pb = [x3gsp getnext];
        if ( NULL == pb ) break;
        /*delete pb;*/ count++;
    }

    //int tm1ms = tm1.elapsed();
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    NSUInteger timeInt = timeInterval;
    //qDebug("number of commands:%d", count);
    //qDebug("time for parsing:%ds:%dms", timeInt, timeInterval - timeInt);
    //x3gsp.statisticdbgprint();

    return count;
}

@end






