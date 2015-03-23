//
//  connection.h
//  RepetierHost
//
//  Created by York on 15/3/21.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "serial.h"
#import "x3gstreamparser.h"
#import "x3gstreamprocess.h"
#import "PrinterConfiguration.h"
#import "ORSSerialPort.h"

@interface Printer_connection : NSObject {
    int m_cmdcount;
    NSString *m_strfile;
    serial::Serial m_com;
    CX3gStreamParser *m_x3gsp;
    X3gStreamInterface* m_x3gsi;
    BotBuildStat m_stat;
}
-(id)init;
-(void)slotbotstateupdate:(int) stat;
-(void)slotbotpercentageupdate:(long)execcnt;
-(void)on_btnX3gFileOpen_clicked;
-(void)on_btnX3gFileStart_clicked;
-(void)on_btnX3gFilePause_clicked;

@end
