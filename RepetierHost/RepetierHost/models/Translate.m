//
//  NSObject_Translate.h
//  RepetierHost
//
//  Created by York on 15/3/23.
//  Copyright (c) 2015年 Repetier. All rights reserved.
//

#import "Translate.h"

@implementation Translate

+(NSString*) translate:(NSString*) in_string
{
    if ([in_string containsString:@"L_L_EXTRUDER"]) {
        return @"Left";
    }
    if ([in_string containsString:@"L_R_EXTRUDER"]) {
        return @"Right";
    }
    if ([in_string containsString:@"L_DUAL_EXTRUDER"]) {
        return @"Dual";
    }
    return nil;
}

@end
