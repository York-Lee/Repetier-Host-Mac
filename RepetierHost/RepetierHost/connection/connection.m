//
//  connection.m
//  RepetierHost
//
//  Created by York on 15/3/21.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import "connection.h"

@implementation Printer_connection

-(id) init
{
    ORSSerialPort *serialPort = [ORSSerialPort serialPortWithPath:@"/dev/tty.usbmodem1451"];
    //NSData* someData = [[NSData alloc] init];
    serialPort.baudRate = @115200;
    [serialPort open];
    //[serialPort sendData:someData]; // someData is an NSData object
    [serialPort close];
    /*serial::Timeout to = serial::Timeout::simpleTimeout(500);
    NSString* NSportname = [currentPrinterConfiguration port];
    std::string *portname = new std::string([NSportname UTF8String]);
    m_com.setPort(*portname);
    m_com.setBaudrate(115200);
    m_com.setTimeout(to);
    m_com.open();*/
    NSLog(@"Init x3gsi, x3gsp");
    m_x3gsp = [[CX3gStreamParser alloc] init];
    //m_x3gsi = [[X3gStreamInterface alloc] initWithTarget:[X3gStreamInterface class] selector:@selector(run:) object:nil];
    //[m_x3gsi setupinit:serialPort :&m_x3gsp];
    NSLog(@"%@", serialPort.baudRate);
    m_x3gsi = [[X3gStreamInterface alloc] init:serialPort :&m_x3gsp];
    NSLog(@"%@", [m_x3gsi getbaudrate]);
    NSLog(@"set filename");
    m_strfile = @"/Users/liyingkai/Desktop/leveling-150x150.x3g";
    return self;
}

-(void)on_btnX3gFileOpen_clicked
{
    /*QStringList filters;
     filters << "X3g files (*.x3g *.xery)";
     
     // disable input method to walk around
     // bugs in syszuim
     QWSServer::setCurrentInputMethod(NULL);
     
     QFileDialog fd(this);
     fd.setNameFilters(filters);
     fd.setViewMode(QFileDialog::Detail);
     fd.setDirectory("/media/sda1");
     int ierr = fd.exec();
     
     QWSServer::setCurrentInputMethod(m_im);
     if ( 0 == ierr ) return;
     
     m_strfile = fd.selectedFiles().at(0).toLocal8Bit().constData();*/
    
    NSLog(@"get count");
    m_cmdcount = [CX3gStreamParser getcount:m_strfile];
    if ( m_cmdcount <= 0 ) {
        NSLog(@"x3g stream parser open file fail");
        return;
    }
    NSLog(@"number of commands:%d", m_cmdcount);
    
    /*ui->edtFileName->setText(m_strfile);
     buttonstatusupdate();*/
}

-(void)on_btnX3gFileStart_clicked
{
    NSLog(@"Started");
    if ( BUILD_STAT_NONE == m_stat ||
        BUILD_STAT_CANCELED == m_stat ||
        BUILD_STAT_FINISHED_NORMALLY == m_stat )
    {
        NSLog(@"Open");
        [m_x3gsp open:m_strfile];
        [m_x3gsi setrunflag:true];
        //[NSThread detachNewThreadSelector:@selector(run) toTarget:[m_x3gsi class] withObject:nil];
        [m_x3gsi startbuild];
        //[m_x3gsi start];
        //[m_x3gsi run];//[m_x3gsi start];
    }
    else {
        /*m_x3gsi->setrunflag(false);
         m_x3gsi->wait();m_x3gsp.close();*/
        [m_x3gsi cancelbuild];
    }
}

-(void)on_btnX3gFilePause_clicked
{
    [m_x3gsi pausebuild];
}

/*-(void)on_btnSettings_clicked
 {
 DialogSettings dlgset(&m_com, this);
 dlgset.exec();
 }*/

-(void)slotbotstateupdate:(int) stat
{
    m_stat = (BotBuildStat)stat;
    /*QString info = m_slbuildstat.at(stat);
     m_lblbuildstate->setText(info);*/
    
    switch ( m_stat )
    {
        case BUILD_STAT_FINISHED_NORMALLY:
            [m_x3gsi setrunflag:false];
            [m_x3gsi wait];[m_x3gsp close];
            //buttonstatusupdate();
            NSLog(@"slotbotstateupdate: finished normally...");
            break;
            
        case BUILD_STAT_CANCELED:
            [m_x3gsi setrunflag:false];
            [m_x3gsi wait];[m_x3gsp close];
            //buttonstatusupdate();
            NSLog(@"slotbotstateupdate: canceled...");
            break;
            
        case BUILD_STAT_CANNELLING:
            NSLog(@"slotbotstateupdate: canelling...");
            break;
            
        case BUILD_STAT_PAUSED:
            //buttonstatusupdate();
            NSLog(@"slotbotstateupdate: paused...");
            break;
            
        case BUILD_STAT_RUNNING:
            //buttonstatusupdate();
            NSLog(@"slotbotstateupdate: running...");
            break;
            
        case BUILD_STAT_NONE:
            // TODO: should not update buttons status here
            // buttonstatusupdate();
            NSLog(@"slotbotstateupdate: build state none???");
            break;
    }
}

@end
