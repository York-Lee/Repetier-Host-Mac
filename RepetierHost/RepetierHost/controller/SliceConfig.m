//
//  SliceConfig.m
//  RepetierHost
//
//  Created by York on 15/2/4.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import "SliceConfig.h"
#import "PrinterConfiguration.h"
#import "Translate.h"
#import "IniFile.h"
#import "STL.h"
#import "RHTask.h"
#import "RHAppDelegate.h"
#import "RHSlicer.h"
#import "STLComposer.h"

@interface SliceConfig ()

@end

@implementation SliceConfig

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    single_r225_config = [NSArray arrayWithObjects:@"single_r_print", @"single_filament", @"single_r225_printer", nil];
    single_l225_config = [NSArray arrayWithObjects:@"single_l_print", @"single_filament", @"single_l225_printer", nil];
    single_r300_config = [NSArray arrayWithObjects:@"single_r_print", @"single_filament", @"single_r300_printer", nil];
    single_l300_config = [NSArray arrayWithObjects:@"single_l_print", @"single_filament", @"single_l300_printer", nil];
    dual_225_config = [NSArray arrayWithObjects:@"dual_print", @"dual_filament", @"support_filament", @"dual_225_printer", nil];
    dual_300_config = [NSArray arrayWithObjects:@"dual_print", @"dual_filament", @"support_filament", @"dual_300_printer", nil];
    lapple_config = [NSArray arrayWithObjects:@"lapple_print", @"lapple_filament", @"lapple_printer" , nil];
    machineType_config = [NSArray arrayWithObjects:@"SMART225P", @"SMART300M", @"LAPPLE100" , nil];
    slicedir = @"~/Library/Application Support/Slic3r";
    file_1 = [[NSMutableString alloc] initWithString:@""];
    file_2 = [[NSMutableString alloc] initWithString:@""];
    file_3 = [[NSMutableString alloc] initWithString:@""];
    file_4 = [[NSMutableString alloc] initWithString:@""];
}

- (IBAction)sliceButtonHit:(id)sender {
    [self SelectMachineType];
    NSLog(@"Machine done");
    [self Select_Extruder];
    NSLog(@"truder done");
    [app->composer generateGCode:nil];
}

void runSystemCommand(NSString *cmd)
{
    [[NSTask launchedTaskWithLaunchPath:@"/bin/sh"
                              arguments:[NSArray arrayWithObjects:@"-c", cmd, nil]]
     waitUntilExit];
}

-(void)SelectMachineType
{
    single_r225_config = [NSArray arrayWithObjects:@"single_r_print", @"single_filament", @"single_r225_printer", nil];
    single_l225_config = [NSArray arrayWithObjects:@"single_l_print", @"single_filament", @"single_l225_printer", nil];
    single_r300_config = [NSArray arrayWithObjects:@"single_r_print", @"single_filament", @"single_r300_printer", nil];
    single_l300_config = [NSArray arrayWithObjects:@"single_l_print", @"single_filament", @"single_l300_printer", nil];
    dual_225_config = [NSArray arrayWithObjects:@"dual_print", @"dual_filament", @"support_filament", @"dual_225_printer", nil];
    dual_300_config = [NSArray arrayWithObjects:@"dual_print", @"dual_filament", @"support_filament", @"dual_300_printer", nil];
    lapple_config = [NSArray arrayWithObjects:@"lapple_print", @"lapple_filament", @"lapple_printer" , nil];
    machineType_config = [NSArray arrayWithObjects:@"SMART225P", @"SMART300M", @"LAPPLE100" , nil];
    
    NSString* seletedmachineType = [[printerType objectValueOfSelectedItem] lowercaseString];//machineType_ComboBox.SelectedItem.ToString().ToLower();
    if ([seletedmachineType containsString:@"smart-225p"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_R_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [single_r225_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [single_r225_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rPrinter = [single_r225_config objectAtIndex:2];
        machineType = [machineType_config objectAtIndex:0];
    }
    if ([seletedmachineType containsString:@"smart-225p"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_L_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [single_l225_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [single_l225_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rPrinter = [single_l225_config objectAtIndex:2];
        machineType = machineType = [machineType_config objectAtIndex:0];
    }
    if ([seletedmachineType containsString:@"smart-300m"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_R_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [single_r300_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [single_r300_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rPrinter = [single_r300_config objectAtIndex:2];
        machineType = machineType = [machineType_config objectAtIndex:1];
    }
    if ([seletedmachineType containsString:@"smart-300m"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_L_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [single_l300_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [single_l300_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rPrinter = [single_l300_config objectAtIndex:2];
        machineType = machineType = [machineType_config objectAtIndex:1];
    }
    if ([seletedmachineType containsString:@"smart-225p"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_DUAL_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [dual_225_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [dual_225_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rFilament2 = [dual_225_config objectAtIndex:2];
        currentPrinterConfiguration.Slic3rPrinter = [dual_225_config objectAtIndex:3];
        machineType = machineType = [machineType_config objectAtIndex:0];
    }
    if ([seletedmachineType containsString:@"smart-300m"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_DUAL_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [dual_300_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [dual_300_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rFilament2 = [dual_300_config objectAtIndex:2];
        currentPrinterConfiguration.Slic3rPrinter = [dual_300_config objectAtIndex:3];
        machineType = machineType = [machineType_config objectAtIndex:1];
    }
    if ([seletedmachineType containsString:@"lapple"] && [[extruder objectValueOfSelectedItem] containsString:[Translate translate:@"L_R_EXTRUDER"]])
    {
        currentPrinterConfiguration.Slic3rPrint = [lapple_config objectAtIndex:0];
        currentPrinterConfiguration.Slic3rFilament1 = [lapple_config objectAtIndex:1];
        currentPrinterConfiguration.Slic3rPrinter = [lapple_config objectAtIndex:2];
        machineType = machineType = [machineType_config objectAtIndex:2];
    }
}

-(IBAction)extruderBoxClicked:(id) sender
{
    [self Select_Extruder];
}

-(void)Select_Extruder
{
    //parameterTabControl.SelectedIndex = 1;
    if ([[extruder objectValueOfSelectedItem] containsString:@"Left"])//@"L_R_EXTRUDER"])
    {
        // supportCBox.Text = extruderCBox.Text;
        [rightExtruderTemperature setEnabled:false];
        //rightLbl.Enabled = false;
        [leftExtruderTemperature setEnabled:true];
        //leftLbl.Enabled = true;
        currentPrinterConfiguration->numberOfExtruder = 1;
    }
    if ([[extruder objectValueOfSelectedItem] containsString:@"Right"])//@"L_L_EXTRUDER"])
    {
        currentPrinterConfiguration->numberOfExtruder = 1;
        [rightExtruderTemperature setEnabled:true];
        //rightLbl.Enabled = true;
        [leftExtruderTemperature setEnabled:false];
        //leftLbl.Enabled = false;
    }
    if ([[extruder objectValueOfSelectedItem] containsString:@"Dual"])//@"L_DUAL_EXTRUDER"])
    {
        [rightExtruderTemperature setEnabled:true];
        //rightLbl.Enabled = true;
        [leftExtruderTemperature setEnabled:true];
        //leftLbl.Enabled = true;
        //  comboSlic3rFilamentSettings2.Enabled = true;
        currentPrinterConfiguration->numberOfExtruder = 2;
    }
}

-(void)InfillRatioBox_Validated
{
    /*TextBox box = (TextBox)sender;
    //supportCBox.Text = extruderCBox.Text;
    leftExtruderTextBox.Enabled = true;
    leftLbl.Enabled = true;
    rightExtruderTextBox.Enabled = false;
    rightLbl.Enabled = false;*/
    //  comboSlic3rFilamentSettings2.Enabled = false;
    @try
    {
        infill_rate = [infill floatValue];
        //float.Parse(box.Text, NumberStyles.Float);
        if (infill_rate >= 0 && infill_rate < 100)
        {
            //errorProvider1.Clear();
        }
        else
        {
            //errorProvider1.SetError(box,Trans.IdTranslation("L_INFILL_INPUT_TOOLTIP"));
            //box.SelectAll();
            //box.Focus();
        }
    }
    @catch (NSException *e)
    {
        //errorProvider1.SetError(box, Trans.IdTranslation("L_INFILL_INPUT_TOOLTIP"));
    }
}

-(void)Height_Input_valiated
{
    //TextBox box = (TextBox)sender;
    @try
    {
        layer_height = [layerHeight floatValue];
        if (layer_height > 0.4 || layer_height < 0.1)
        {
            //errorProvider1.SetError(box, Trans.IdTranslation("L_HEIGHT_INPUT_TOOLTIP"));
            //box.SelectAll();
            //box.Focus();
        }
        else
        {
            //errorProvider1.Clear();
        }
    }
    @catch (NSException *e)
    {
        //errorProvider1.SetError(box, Trans.IdTranslation("L_HEIGHT_INPUT_TOOLTIP"));
    }
}

-(void)Traveling_Speed_Validated
{
    //TextBox box = (TextBox)sender;
    @try
    {
        travel_speed = [travelSpeed floatValue];
        if (travel_speed < 60)
        {
            //errorProvider1.SetError(box, Trans.IdTranslation("L_TRAVELING_SPEED_INPUT_TOOLTIP"));
            //box.SelectAll();
            //box.Focus();
        }
        else
        {
            //errorProvider1.Clear();
        }
    }
    @catch (NSException *e)
    {
        //errorProvider1.SetError(box, Trans.IdTranslation("L_TRAVELING_SPEED_INPUT_TOOLTIP "));
    }
}

-(void)ExtrudingTextBox_Validated
{
    //TextBox box = (TextBox)sender;
    @try
    {
        printer_speed = [printSpeed floatValue];
        if (printer_speed < 40)
        {
            //errorProvider1.SetError(box, Trans.IdTranslation("L_EXTRUDER_SPEED_INPUT_TOOLTIP"));
            //box.SelectAll();
            //box.Focus();
        }
        else
        {
            //errorProvider1.Clear();
        }
    }
    @catch (NSException *e)
    {
        //errorProvider1.SetError(box, Trans.IdTranslation("L_TRAVELING_SPEED_INPUT_TOOLTIP "));
    }
}

-(bool)loadConfigFile
{
    NSFileManager *fm=[NSFileManager defaultManager];
    /*[file_1 appendString:cdir];
    [file_1 appendString:@"/print/"];
    [file_1 appendString:Main.printerModel.Slic3rPrint];
    [file_1 appendString:@".ini"];
    [file_2 appendString:cdir];
    [file_2 appendString:@"/printer/"];
    [file_2 appendString:Main.printerModel.Slic3rPrinter];
    [file_2 appendString:@".ini"];
    [file_3 appendString:cdir];
    [file_3 appendString:@"/filament/"];
    [file_3 appendString:Main.printerModel.Slic3rFilament1];
    [file_3 appendString:@".ini"];
    [file_4 appendString:cdir];
    [file_4 appendString:@"/filament/"];
    [file_4 appendString:Main.printerModel.Slic3rFilament2];
    [file_4 appendString:@".ini"];*/

    if(![fm fileExistsAtPath:file_3])
    {
        //[fm createFileAtPath:file_3 contents:data attributes:nil];
        return false;
    }
    NSData *data2, *data3, *data4;
    data2=[fm contentsAtPath:file_2];
    data3=[fm contentsAtPath:file_3];
    if (numberExtruder > 1)
    {
        if(![fm fileExistsAtPath:file_3])
        {
            return false;
        }
        data4=[fm contentsAtPath:file_4];
    }
    NSMutableData *filementData = [[NSMutableData alloc] initWithLength:0];
    [filementData appendData:data3];
    if (numberExtruder > 1)
    {
        [filementData appendData:data4];
    }
    NSMutableData *data = [[NSMutableData alloc] initWithLength:0];
    [data appendData:data2];
    [data appendData:filementData];
    [fm removeItemAtPath:file_1 error:nil];
    [fm createFileAtPath:file_1 contents:data attributes:nil];
    
    /*NSString *config = "\"" + dir + "/slic3r.ini\"";
    NSMutableString *cmdString = [[NSMutableString alloc] initWithString:@""];
    [cmdString appendString:@"--load "];
    [cmdString appendString:config];
    [cmdString appendString:@" --layer-height "];
    [cmdString appendString:[NSString stringWithFormat:@"%f", layer_height]];
    [cmdString appendString:@" --fill-density "];
    [cmdString appendString:[NSString stringWithFormat:@"%.2f", infill_rate]];
    [cmdString appendString:@" --print-center "];
    [cmdString appendString:centerx.ToString("0", GCode.format)];
    [cmdString appendString:@","];
    [cmdString appendString:centery.ToString("0", GCode.format)];
    [cmdString appendString:@" -o "];
    [cmdString appendString:wrapQuotes(StlToGCode(file))];
    [cmdString appendString:@" "];
    [cmdString appendString:wrapQuotes(file)];
    
    RLog.info("Slic3r command:" + exe + " " + builder.ToString());*/
    return true;
}

- (IBAction)killSliceButtonHit:(id)sender {
    
}


@end
