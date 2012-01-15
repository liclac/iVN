//
//  ScriptInterpreter.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "ScriptInterpreter.h"
#import "Novel.h"
#import "Script.h"
#import "State.h"
#import "Command.h"
#import "Variable.h"
#import "Sprite.h"
#import "Save.h"

@implementation ScriptInterpreter
@synthesize novel, skipping, delegate;

- (id)initWithNovel:(Novel *)aNovel
{
    if((self = [super init]))
	{
		novel = [aNovel retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLoaded) name:VNNotificationSaveLoaded object:nil];
    }
    
    return self;
}

- (void)processNextCommand:(NSTimer *)aTimer
{
	[nextFrameTimer invalidate];
	[nextFrameTimer release];
	nextFrameTimer = nil;
	
	if(choiceOpen) return; //Don't proceed past open choices
	
	continueExecuting = NO;
	
	//Return to 'main.scr' if about to run past the end of the script instead of crashing
	if([novel.currentState.script.commands count] <= novel.currentState.position)
	{
		MTLog(@"Exceeded the end of the script");
		[self jumpToScript:@"main.scr" position:0];
		return;
	}
	
	Command *cmd = [novel.currentState.script.commands objectAtIndex:novel.currentState.position];
	novel.currentState.position++; //Do this AFTER getting cmd, otherwise we'll skip the first command by starting at 1 instead of 0
	
	switch (cmd.type)
	{
		case VNCommandTypeBGLOAD:
			[self forwardSelector:@selector(interpreter:processBGLOAD:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeSETIMG:
			[self forwardSelector:@selector(interpreter:processSETIMG:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeSOUND:
			[self forwardSelector:@selector(interpreter:processSOUND:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeMUSIC:
			[self forwardSelector:@selector(interpreter:processMUSIC:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeTEXT:
			[self forwardSelector:@selector(interpreter:processTEXT:) withCommand:cmd];
			novel.currentState.textSkip++; //Count the text commands separately
			break;
			
		case VNCommandTypeCHOICE:
			[self forwardSelector:@selector(interpreter:processCHOICE:) withCommand:cmd];
			continueExecuting = NO; //We must NOT proceed past choices
			skipping = NO; //Stop skipping
			choiceOpen = YES; //Mark a choice as open
			break;
			
		case VNCommandTypeSETVAR:
			[self forwardSelector:@selector(interpreter:processSETVAR:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeGSETVAR:
			[self forwardSelector:@selector(interpreter:processGSETVAR:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeIF:
			[self forwardSelector:@selector(interpreter:processIF:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeFI:
			[self forwardSelector:@selector(interpreter:processFI:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeJUMP:
			[self forwardSelector:@selector(interpreter:processJUMP:) withCommand:cmd];
			break;
			
		case VNCommandTypeDELAY:
			[self forwardSelector:@selector(interpreter:processDELAY:) withCommand:cmd];
			continueExecuting = YES;
			nextFrameDelay = [[cmd.parameters objectAtIndex:0] intValue]/100;
			break;
			
		case VNCommandTypeRANDOM:
			[self forwardSelector:@selector(interpreter:processRANDOM:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeSKIP:
			[self forwardSelector:@selector(interpreter:processSKIP:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeENDSCRIPT:
			[self forwardSelector:@selector(interpreter:processENDSCRIPT:) withCommand:cmd];
			break;
			
		case VNCommandTypeLABEL:
			[self forwardSelector:@selector(interpreter:processLABEL:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		case VNCommandTypeGOTO:
			[self forwardSelector:@selector(interpreter:processGOTO:) withCommand:cmd];
			break;
			
		case VNCommandTypeCLEARTEXT:
			[self forwardSelector:@selector(interpreter:processCLEARTEXT:) withCommand:cmd];
			continueExecuting = YES;
			break;
			
		default: //Ignore unknown command types
			continueExecuting = YES;
			break;
	}
	
	if((continueExecuting || skipping) && !fastForwarding)
	{
		if(nextFrameDelay > 0)
			nextFrameTimer = [[NSTimer scheduledTimerWithTimeInterval:nextFrameDelay target:self selector:@selector(processNextCommand:)
															 userInfo:nil repeats:NO] retain];
		else [self processNextCommand:nil];
	}
}

- (void)forwardSelector:(SEL)selector withCommand:(Command *)cmd
{
	if([self respondsToSelector:selector]) [self performSelector:selector withObject:self withObject:cmd];
	
	if(fastForwarding) return; //Don't forward any further if fast-forwarding
	if([novel respondsToSelector:selector]) [novel performSelector:selector withObject:self withObject:cmd];
	if([delegate respondsToSelector:selector]) [delegate performSelector:selector withObject:self withObject:cmd];
}


#pragma mark self-delegation
- (void)interpreter:(ScriptInterpreter *)si processBGLOAD:(Command *)command
{
	/*if(!fastForwarding) return;
	
	[fastForwardState.sprites removeAllObjects];
	fastForwardState.background = [command.parameters objectAtIndex:0];*/
}

- (void)interpreter:(ScriptInterpreter *)si processSETIMG:(Command *)command
{
	/*if(!fastForwarding) return;
	
	Sprite *sprite = [[Sprite alloc] initWithPath:[command.parameters objectAtIndex:0] absPath:[novel relativeToAbsolutePath:[command.parameters objectAtIndex:0]]
											point:CGPointMake([[command.parameters objectAtIndex:1] integerValue], [[command.parameters objectAtIndex:2] integerValue])];
	[fastForwardState.sprites addObject:sprite];
	[sprite release];*/
}

- (void)interpreter:(ScriptInterpreter *)si processSOUND:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processMUSIC:(Command *)command
{
	//fastForwardState.music = [command.parameters objectAtIndex:0];
}

- (void)interpreter:(ScriptInterpreter *)si processTEXT:(Command *)command
{
	if([command.text length] < 1) return;
	
	if(!fastForwarding)
	{
		if([command.text hasPrefix:@"@"] || [command.text isEqualToString:@"~"])
		{
			continueExecuting = YES;
			if(!skipping) nextFrameDelay = kFrameDelay;
			else nextFrameDelay = kFrameDelay/3;
		}
	}
	else
	{
		[fastForwardTextBuffer addObject:[command text]];
	}
}

- (void)interpreter:(ScriptInterpreter *)si processCHOICE:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processSETVAR:(Command *)command
{
	if(fastForwarding) return;
	
	Variable *var = [[Variable alloc] initWithKey:[command.parameters objectAtIndex:0] value:[command.parameters objectAtIndex:1]];
	[novel.currentState.vars setObject:var forKey:var.key];
	[var release];
}

- (void)interpreter:(ScriptInterpreter *)si processGSETVAR:(Command *)command
{
	if(fastForwarding) return;
	
	Variable *var = [[Variable alloc] initWithKey:[command.parameters objectAtIndex:0] value:[command.parameters objectAtIndex:1]];
	[novel.gvars setObject:var forKey:var.key];
	[var release];
}

- (void)interpreter:(ScriptInterpreter *)si processIF:(Command *)command
{
	if(![self evaluateIF:command]) [self jumpToPosition:[command endPosition]];
	
	continueExecuting = YES;
}

- (void)interpreter:(ScriptInterpreter *)si processFI:(Command *)command
{
	//Do nothing
}

- (void)interpreter:(ScriptInterpreter *)si processJUMP:(Command *)command
{
	if(fastForwarding) return;
	
	[self jumpToScript:[command.parameters objectAtIndex:0]
			  position:([command.parameters count] > 1 ? [[command.parameters objectAtIndex:1] integerValue] : 0)];
}

- (void)interpreter:(ScriptInterpreter *)si processDELAY:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processRANDOM:(Command *)command
{
	//Copy-pasted from VNDS's 'script_interpreter.cpp'
	int high  = [[command.parameters objectAtIndex:2] intValue] + 1;
    int low   = [[command.parameters objectAtIndex:1] intValue];
    int value = (rand() % (high-low)) + low;
	
	NSNumber *valueNumber = [NSNumber numberWithInt:value];
	Variable *var = [[Variable alloc] initWithKey:[command.parameters objectAtIndex:0] value:valueNumber];
	[novel.currentState.vars setObject:var forKey:var.key];
	[var release];
}

- (void)interpreter:(ScriptInterpreter *)si processSKIP:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processENDSCRIPT:(Command *)command
{
	[self jumpToScript:@"main.scr" position:0];
}

- (void)interpreter:(ScriptInterpreter *)si processLABEL:(Command *)command
{
	//Do nothing
}

- (void)interpreter:(ScriptInterpreter *)si processGOTO:(Command *)command
{
	if(fastForwarding) return;
	
	[self jumpToPosition:[[novel.currentState.vars objectForKey:[command.parameters objectAtIndex:0]] integerValue]];
}

- (void)interpreter:(ScriptInterpreter *)si processCLEARTEXT:(Command *)command
{
	[fastForwardTextBuffer removeAllObjects];
}


#pragma mark Actions
- (void)jumpToPosition:(NSInteger)position
{
	MTLog(@"%d", position);
	NSUInteger rangeLength = position - novel.currentState.position;
	if(rangeLength > 0)
	{
		NSArray *skippedCommands = [novel.currentState.script.commands
									subarrayWithRange:NSMakeRange(novel.currentState.position,
																  rangeLength)];
		for(Command *cmd in skippedCommands) if(cmd.type == VNCommandTypeTEXT) novel.currentState.textSkip++;
	}
	
	novel.currentState.position = position;
	continueExecuting = YES;
}

- (void)jumpToScript:(NSString *)script position:(NSInteger)position
{
	MTLog(@"%@:%d", script, position);
	[novel loadScriptWithName:script];
	NSInteger rangeLength = position - novel.currentState.position;
	if(rangeLength > 0)
	{
		NSArray *skippedCommands = [novel.currentState.script.commands
									subarrayWithRange:NSMakeRange(novel.currentState.position,
																  rangeLength)];
		for(Command *cmd in skippedCommands) if(cmd.type == VNCommandTypeTEXT) novel.currentState.textSkip++;
	}
	novel.currentState.position = position;
	continueExecuting = YES;
	[self processNextCommand:nil];
}

- (BOOL)evaluateIF:(Command *)command
{
	MTAssert(command.type == VNCommandTypeIF, @"Not an IF-command! %@", command);
	
	NSString *leftValue = [command.parameters objectAtIndex:0];
	NSString *operator = [command.parameters objectAtIndex:1];
	NSString *rightValue = [command.parameters objectAtIndex:2];
	
	if(leftValue == nil || operator == nil || rightValue == nil)
	{
		MTLog(@"%@", command.parameters);
		MTALog(@"Missing Parameters from command '%@' --> %@ %@ %@", command.string, leftValue, operator, rightValue);
		return NO; //Ignore invalid IFs
	}
	
	//Resolve eventual flags, default to 0 (left value) or string (right value) if there are no matches
	id tmp = nil;
	if((tmp = [novel variableForName:leftValue])) leftValue = [tmp stringValue];
	else leftValue = @"0";
	if((tmp = [novel variableForName:rightValue])) rightValue = [tmp stringValue];
	
	MTLog(@"Resolved: %@ %@ %@", leftValue, operator, rightValue);
	
	BOOL retval = NO;
	if([operator isEqualToString:@"=="]) retval = [leftValue isEqualToString:rightValue];
	else if([operator isEqualToString:@"!="]) retval = ![leftValue isEqualToString:rightValue];
	else if([operator isEqualToString:@">="]) retval = [leftValue intValue] >= [rightValue intValue];
	else if([operator isEqualToString:@"<="]) retval = [leftValue intValue] <= [rightValue intValue];
	else if([operator isEqualToString:@">"]) retval = [leftValue intValue] > [rightValue intValue];
	else if([operator isEqualToString:@"<"]) retval = [leftValue intValue] < [rightValue intValue];
	else
	{
		MTALog(@"Invalid IF-operator in %@: '%@' --> %@ %@ %@",
			   novel.currentState.script.localPath, command.string, leftValue, operator, rightValue);
		retval = NO;
	}
	
	MTLog(@"Retsult: %@", MTStringWithBool(retval));
	return retval;
}


#pragma mark - Actions
- (void)choiceClosed:(ChoiceViewController *)choice
{
	choiceOpen = NO;
	[self processNextCommand:nil];
}

- (void)saveLoaded:(Save *)save
{
	MTMark();
	fastForwarding = YES;
	fastForwardTextBuffer = [[NSMutableArray alloc] init];
	
	NSInteger targetTS = novel.currentState.textSkip;
	novel.currentState.position = 0;
	novel.currentState.textSkip = 0;
	
	while(novel.currentState.textSkip < targetTS) [self processNextCommand:nil];
	
	fastForwarding = NO;
	MTLog(@"%d %d", novel.currentState.position, novel.currentState.textSkip);
	
	dispatch_async(dispatch_get_main_queue(), ^{[delegate interpreter:self restoreWithTextBuffer:fastForwardTextBuffer];});
}

@end
