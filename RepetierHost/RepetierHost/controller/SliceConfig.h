//
//  SliceConfig.h
//  RepetierHost
//
//  Created by York on 15/2/4.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
}

- (IBAction)sliceButtonHit:(id)sender;
- (IBAction)killSliceButtonHit:(id)sender;

@end
