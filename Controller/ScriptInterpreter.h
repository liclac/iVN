//
//  ScriptInterpreter.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInterpreterDelegate.h"
#import "ChoiceDelegate.h"
@class Novel;
@class Script;
@class State;
@class Save;

#define kFrameDelay 0.1

@interface ScriptInterpreter : NSObject <ChoiceDelegate>
{
	Novel *novel;
	id<ScriptInterpreterDelegate> delegate;
	BOOL continueExecuting; //Skip directly onto the next command
	BOOL fastForwarding; //Fast-forward in order to reach a certain point, generally after loading a save
	BOOL skipping; //User-triggered fast-forwarding, without a specified end point
	NSTimeInterval nextFrameDelay; //Delay until the next frame is auto-triggered
	NSTimer *nextFrameTimer; //Timer for triggering the next frame if continueExecuting is YES
	
	NSMutableArray *fastForwardTextBuffer; //Text Buffer for restoring after loading
	
	BOOL choiceOpen;
}

@property (nonatomic, retain) Novel *novel;
@property (nonatomic, assign) BOOL skipping;
@property (nonatomic, assign) id<ScriptInterpreterDelegate> delegate;

- (id)initWithNovel:(Novel *)novel;

/**
 * Process the next command in the current script
 * @param timer the timer that fired the frame; must be 'nextFrameTimer' or nil
 */
- (void)processNextCommand:(NSTimer *)timer;

/**
 * Forward the given selector to self, the novel and the delegate object, in that order, if they respond to it.
 */
- (void)forwardSelector:(SEL)selector withCommand:(Command *)cmd;

/**
 * Jumps to the specified command number
 */
- (void)gotoPosition:(NSInteger)position;
- (void)gotoLabel:(NSString *)label;

/**
 * Jumps to the specified file and position
 */
- (void)jumpToScript:(NSString *)script label:(NSString *)label;

/**
 * Evaluates an IF-type command, and returns werther it's true or false
 */
- (BOOL)evaluateIF:(Command *)command;

/**
 * Restore from loaded state
 */
- (void)saveLoaded:(Save *)save;

#if TARGET_IPHONE_SIMULATOR
/**
 * Output a Debug Message in the text log
 */
- (void)debugLog:(NSString *)string;
#endif

@end
