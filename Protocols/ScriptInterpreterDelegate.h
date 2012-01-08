//
//  ScriptInterpreterDelegate.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ScriptInterpreter;
@class Command;

@protocol ScriptInterpreterDelegate <NSObject>

@optional
- (void)interpreter:(ScriptInterpreter *)si processBGLOAD:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processSETIMG:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processSOUND:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processMUSIC:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processTEXT:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processCHOICE:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processSETVAR:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processGSETVAR:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processIF:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processFI:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processJUMP:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processDELAY:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processRANDOM:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processSKIP:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processENDSCRIPT:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processLABEL:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processGOTO:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si processCLEARTEXT:(Command *)command;
- (void)interpreter:(ScriptInterpreter *)si restoreWithTextBuffer:(NSMutableArray *)buffer;

@end
