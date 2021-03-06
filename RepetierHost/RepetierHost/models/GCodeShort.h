//
//  GCodeShort.h
//  RepetierHost
//
//  Created by Roland Littwin on 02.03.12.
//  Copyright (c) 2012 Repetier. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Stores preview relevant codes pre-parsed
 using only 20 bytes extra. This speeds up
 preview 
*/
@interface GCodeShort : NSObject {
    @public
    float x,y,z,e,f,emax;
    // Bit 0-19 : Layer 
    // Bit 20-23 : Tool
    // Bit 24-29 : Compressed command
    // Bit 30 : Contains variables
    uint32_t flags;
    NSString *text;
}
+(GCodeShort*)codeWith:(NSString*)txt;
-(int)layer;
-(void)setLayer:(int)val;
-(BOOL)hasLayer;
-(BOOL)hasVariables;
-(void)setVariables:(BOOL)val;
-(int)tool;
-(void)setTool:(int)val;
-(int)compressedCommand;
-(void)parse;
-(BOOL)hasX;
-(BOOL)hasY;
-(BOOL)hasZ;
-(BOOL)hasE;
-(BOOL)hasF;
-(NSUInteger)length;
-(float)getValueFor:(NSString*) key default:(float)def;
@end
