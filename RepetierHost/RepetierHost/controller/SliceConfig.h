//
//  SliceConfig.h
//  RepetierHost
//
//  Created by York on 15/2/4.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface SliceConfig : NSWindowController {
    IBOutlet NSButton *sliceButtion;
    IBOutlet NSButton *killButtion;
    IBOutlet NSComboBox *printerType;
    IBOutlet NSComboBox *extruder;
    IBOutlet NSTextField *raft;
    IBOutlet NSTextField *infill;
    IBOutlet NSTextField *shell;
    IBOutlet NSTextField *layerHeight;
    IBOutlet NSTextField *leftExtruderTemperature;
    IBOutlet NSTextField *rightExtruderTemperature;
    IBOutlet NSTextField *printSpeed;
    IBOutlet NSTextField *travelSpeed;
    IBOutlet NSStepper *stepper;
    IBOutlet NSButton *checkbox;
    NSString* machineType;
    NSString* extruder_type;
    float infill_rate;
    float layer_height;
    float travel_speed;
    float printer_speed;
    int shells;
    int numberExtruder;
    NSMutableString* file_1;
    NSMutableString* file_2;
    NSMutableString* file_3;
    NSMutableString* file_4;
    NSArray* single_r225_config;
    NSArray* single_l225_config;
    NSArray* single_r300_config;
    NSArray* single_l300_config;
    NSArray* dual_225_config;
    NSArray* dual_300_config;
    NSArray* lapple_config;
}

- (IBAction)sliceButtonHit:(id)sender;
- (IBAction)killSliceButtonHit:(id)sender;

@end
