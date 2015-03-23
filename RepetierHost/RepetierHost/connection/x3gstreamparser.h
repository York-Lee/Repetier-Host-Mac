#ifndef X3GSTREAMPARSER_H
#define X3GSTREAMPARSER_H

//#include <QtGlobal>
//#include <QByteArray>
//#include <QString>
//#include <QFile>
//#include <QVector>
//#include "motherboardcommandcode.h"
#import "packetbuilder.h"

@interface S3gCmdFormat : NSObject {
    int m_cmd, m_parlen;
    int m_subcmd, m_subcmdpos;
    bool m_bparstring;
}
-(id)init;
-(id)init:(S3gCmdFormat* const) val;
//~S3gCmdFormat();
-(id)init:(int) Cmd :(int) Parlen :(int) Subcmd :(int) SubcmdPos :(bool) HasString;// = false;
-(CPacketBuilder*)tryparse:(uint8_t*)stream :(int)pos1 :(int)pos2 :(int*) nextpos;
@end

@interface CX3gStreamParser : NSObject {
    NSMutableArray *m_pattens;//<S3gCmdFormat*> m_pattens;
    int m_buffpos, m_bufflen;
    int* m_cmdstatistic;
    int8_t* m_buffer;
    NSString *m_file;
    NSFileHandle *fileHandle;
    NSCondition *condition;
}
-(id)init;
//~CX3gStreamParser();
-(bool)open:(NSString*) strFile;
-(bool)isopen;
-(void)close;
-(void)statisticreset;
-(void)statisticdbgprint;
-(CPacketBuilder*) getnext;
-(NSString*)getfile;
+(int)getcount:(NSString*) strfile;
@end

/*class S3gCmdFormat
{
public:
    S3gCmdFormat();
    S3gCmdFormat(const S3gCmdFormat& val);
    S3gCmdFormat(int Cmd, int Parlen, int Subcmd, int SubcmdPos, bool HasString = false);
    ~S3gCmdFormat();

public:
    CPacketBuilder* tryparse(quint8* stream, int pos1, int pos2, int& nextpos);

private:
    int m_cmd, m_parlen;
    int m_subcmd, m_subcmdpos;
    bool m_bparstring;
};

class CX3gStreamParser
{
public:
    CX3gStreamParser();
    ~CX3gStreamParser();

public:
    bool open(QString strFile);
    bool isopen();
    void close();
    void statisticreset();
    void statisticdbgprint();
    CPacketBuilder* getnext();
    static int getcount(QString strfile);

private:
    static const int m_buffsize;
    static const int m_bufflentoparse;
    QVector<S3gCmdFormat*> m_pattens;
    int m_buffpos, m_bufflen;
    int* m_cmdstatistic;
    quint8* m_buffer;
    QFile m_file;
};*/

#endif // X3GSTREAMPARSER_H
