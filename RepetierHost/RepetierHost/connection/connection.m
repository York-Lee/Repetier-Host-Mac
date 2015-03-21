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
    serial::Timeout to = serial::Timeout::simpleTimeout(500);
    /*NSString* NSportname = [currentPrinterConfiguration port];
    std::string *portname = new std::string([NSportname UTF8String]);
    m_com.setPort(*portname);*/
    std::string portname = "usbmodem1411";
    m_com.setPort(portname);
    m_com.setBaudrate(115200);
    m_com.setTimeout(to);
    m_com.open();
    m_x3gsi = [[X3gStreamInterface alloc] init:&m_com :m_x3gsp];
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
    
    m_cmdcount = [CX3gStreamParser getcount:m_strfile];
    if ( m_cmdcount <= 0 ) {
        //qDebug("x3g stream parser open file fail");
        return;
    }
    
    /*ui->edtFileName->setText(m_strfile);
     buttonstatusupdate();*/
}

-(void)on_btnX3gFileStart_clicked
{
    if ( BUILD_STAT_NONE == m_stat ||
        BUILD_STAT_CANCELED == m_stat ||
        BUILD_STAT_FINISHED_NORMALLY == m_stat )
    {
        [m_x3gsp open:m_strfile];
        [m_x3gsi setrunflag:true];
        [m_x3gsi startbuild];
        [m_x3gsi start];
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
            /*[m_x3gsi wait];*/[m_x3gsp close];
            //buttonstatusupdate();
            //qDebug("slotbotstateupdate: finished normally...");
            break;
            
        case BUILD_STAT_CANCELED:
            [m_x3gsi setrunflag:false];
            /*[m_x3gsi wait];*/[m_x3gsp close];
            //buttonstatusupdate();
            //qDebug("slotbotstateupdate: canceled...");
            break;
            
        case BUILD_STAT_CANNELLING:
            //qDebug("slotbotstateupdate: canelling...");
            break;
            
        case BUILD_STAT_PAUSED:
            //buttonstatusupdate();
            //qDebug("slotbotstateupdate: paused...");
            break;
            
        case BUILD_STAT_RUNNING:
            //buttonstatusupdate();
            //qDebug("slotbotstateupdate: running...");
            break;
            
        case BUILD_STAT_NONE:
            // TODO: should not update buttons status here
            // buttonstatusupdate();
            //qDebug() << "slotbotstateupdate: build state none???";
            break;
    }
}

@end
