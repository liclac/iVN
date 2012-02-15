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

#if TARGET_IPHONE_SIMULATOR
	#define DBGLOG(...) MTLog(__VA_ARGS__); [self debugLog:[NSString stringWithFormat:__VA_ARGS__]]
#else
	#define DBGLOG(...) do {} while (0);
#endif

@implementation ScriptInterpreter
@synthesize novel, skipping, delegate;

- (id)initWithNovel:(Novel *)aNovel
{
    if((self = [super init]))
	{
		novel = [aNovel retain];
		[novel loadScriptWithName:@"main.scr"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLoaded) name:VNNotificationSaveLoaded object:nil];
    }
    
    return self;
}

- (void)processNextCommand:(NSTimer *)aTimer
{
	[nextFrameTimer invalidate];
	[nextFrameTimer release];
	nextFrameTimer = nil;
	nextFrameDelay = kFrameDelay;
	
	if(choiceOpen) return; //Don't proceed past open choices
	
	continueExecuting = NO;
	
	//Return to 'main.scr' if about to run past the end of the script instead of crashing
	if([novel.currentState.script.commands count] <= novel.currentState.position)
	{
		MTLog(@"Exceeded the end of the script");
		MTLog(@"Loaded Commands: (%d <= %d)\n%@",
			  [novel.currentState.script.commands count], novel.currentState.position, novel.currentState.script.commands);
		[self jumpToScript:@"main.scr" label:nil];
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
			nextFrameDelay = [[cmd parameterAtIndex:0 defaultValue:nil] intValue]/100;				//<--
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
		else
			[self processNextCommand:nil];
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
	
}

- (void)interpreter:(ScriptInterpreter *)si processSETIMG:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processSOUND:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processMUSIC:(Command *)command
{
	if(fastForwarding) [delegate interpreter:si processMUSIC:command];
}

- (void)interpreter:(ScriptInterpreter *)si processTEXT:(Command *)command
{
	if([command.text length] < 1) return;
	
	if(!fastForwarding)
	{
		if([command.text hasPrefix:@"@"] || [command.text isEqualToString:@"~"])
		{
			continueExecuting = YES;
			if(!skipping)
				nextFrameDelay = kFrameDelay;
			else
				nextFrameDelay = ((float)kFrameDelay)/3.0;
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
	if(skipping) return;
	
	NSString *key = [command parameterAtIndex:0 defaultValue:nil];
	NSString *value = [command parameterAtIndex:1 defaultValue:nil];
	if([value isEqualToString:@"="] && [command parameterCount] > 2) value = [command parameterAtIndex:2 defaultValue:nil];
	if([value isEqualToString:@"~"])
	{
		if([key isEqualToString:@"~"])
		{
			DBGLOG(@"Unsetting All Flags...");
			[novel.currentState.vars removeAllObjects];
		}
		else
		{
			DBGLOG(@"Unsetting Flag '%@'...", key);
			[novel.currentState.vars removeObjectForKey:key];
		}
	}
	else
	{
		Variable *var = [[Variable alloc] initWithKey:key value:value flagsFromNovel:novel];
		DBGLOG(@"Setting %@ = (%@) %@", var.key, NSStringFromClass([var->value class]), var->value);
		[novel.currentState.vars setObject:var forKey:var.key];
		[var release];
	}
	
	continueExecuting = YES;
}

- (void)interpreter:(ScriptInterpreter *)si processGSETVAR:(Command *)command
{
	if(skipping) return;
	
	NSString *key = [command parameterAtIndex:0 defaultValue:nil];
	NSString *value = [command parameterAtIndex:1 defaultValue:nil];
	if([value isEqualToString:@"="] && [command parameterCount] > 2) value = [command parameterAtIndex:2 defaultValue:nil];
	Variable *var = [[Variable alloc] initWithKey:key value:value flagsFromNovel:novel];
	DBGLOG(@"G-Setting %@ = %@", key, value);
	[novel.gvars setObject:var forKey:var.key];
	[var release];
	
	continueExecuting = YES;
}

- (void)interpreter:(ScriptInterpreter *)si processIF:(Command *)command
{
	if(skipping) return;
	if(![self evaluateIF:command]) [self gotoPosition:[command endPosition]];
	
	continueExecuting = YES;
}

- (void)interpreter:(ScriptInterpreter *)si processFI:(Command *)command
{
	//Do nothing
}

- (void)interpreter:(ScriptInterpreter *)si processJUMP:(Command *)command
{
	if(fastForwarding) return;
	
	NSString *script = [[command parameterAtIndex:0 defaultValue:nil maybeVariable:YES] stringValue];
	NSString *label = [[command parameterAtIndex:1 defaultValue:nil maybeVariable:YES] stringValue];
	DBGLOG(@"CMD-Jump %@:%@", script, label);
	/*[self jumpToScript:script
			  position:[[novel.currentState.script.labels objectForKey:label] integerValue]];*/
	[self jumpToScript:script label:label];
	MTLog(@"Labels:\n%@", novel.currentState.script.labels);
}

- (void)interpreter:(ScriptInterpreter *)si processDELAY:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processRANDOM:(Command *)command
{
	//Copy-pasted from VNDS's 'script_interpreter.cpp'
	int high  = [[command parameterAtIndex:2 defaultValue:nil] intValue] + 1;
    int low   = [[command parameterAtIndex:1 defaultValue:nil] intValue];
    int value = (rand() % (high-low)) + low;
	
	NSNumber *valueNumber = [NSNumber numberWithInt:value];
	Variable *var = [[Variable alloc] initWithKey:[command parameterAtIndex:0 defaultValue:nil] value:valueNumber type:VNVariableTypeInt];
	[novel.currentState.vars setObject:var forKey:var.key];
	[var release];
}

- (void)interpreter:(ScriptInterpreter *)si processSKIP:(Command *)command
{
	
}

- (void)interpreter:(ScriptInterpreter *)si processENDSCRIPT:(Command *)command
{
	[self jumpToScript:@"main.scr" label:nil];
}

- (void)interpreter:(ScriptInterpreter *)si processLABEL:(Command *)command
{
	//Do nothing
}

- (void)interpreter:(ScriptInterpreter *)si processGOTO:(Command *)command
{
	if(fastForwarding) return;
	
	//[self jumpToPosition:[[novel.currentState.script.labels objectForKey:[command parameterAtIndex:0 defaultValue:nil]] integerValue]];
	[self gotoLabel:[command parameterAtIndex:0 defaultValue:nil maybeVariable:YES]];
}

- (void)interpreter:(ScriptInterpreter *)si processCLEARTEXT:(Command *)command
{
	[fastForwardTextBuffer removeAllObjects];
}


#pragma mark Actions
- (void)gotoPosition:(NSInteger)position
{
	DBGLOG(@"JMP>POS %d/%d", position, [novel.currentState.script.commands count]);
	if(position < novel.currentState.position) //Start over at the beginning if jumping backwards
	{
		novel.currentState.position = 0;
		novel.currentState.textSkip = 0;
	}
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

- (void)gotoLabel:(NSString *)label
{
	NSInteger position = [[novel.currentState.script.labels objectForKey:label] integerValue];
	[self gotoPosition:position];
}

- (void)jumpToScript:(NSString *)script label:(NSString *)label
{
	[novel loadScriptWithName:script];
	if(label != nil) [self gotoLabel:label];
	[self processNextCommand:nil];
}

- (BOOL)evaluateIF:(Command *)command
{
	MTAssert(command.type == VNCommandTypeIF, @"Not an IF-command! %@", command);
	
	NSString *leftValue = [command parameterAtIndex:0 defaultValue:nil];
	NSString *operator = [command parameterAtIndex:1 defaultValue:nil];
	NSString *rightValue = [command parameterAtIndex:2 defaultValue:nil];
	
	if(leftValue == nil || operator == nil || rightValue == nil)
	{
		MTALog(@"Missing Parameters from command '%@' --> %@ %@ %@", command.string, leftValue, operator, rightValue);
		return NO; //Ignore invalid IFs
	}
	
	//Resolve eventual flags, default to 0 (left value) or string (right value) if there are no matches
	id tmp = nil;
	if((tmp = [novel variableForName:leftValue]))
	{
		DBGLOG(@"IF: Resolved L-Variable '%@' = '%@'", leftValue, tmp);
		leftValue = [tmp stringValue];
	}
	else leftValue = @"0";
	if((tmp = [novel variableForName:rightValue]))
	{
		DBGLOG(@"IF: Resolved R-Variable '%@' = '%@'", rightValue, tmp);
		rightValue = [tmp stringValue];
	}
	
	MTLog(@"IF: Resolved: %@ %@ %@", leftValue, operator, rightValue);
	
	BOOL retval = NO;
	if([operator isEqualToString:@"=="]) retval = [leftValue isEqualToString:rightValue];
	else if([operator isEqualToString:@"!="]) retval = ![leftValue isEqualToString:rightValue];
	else if([operator isEqualToString:@">="]) retval = [leftValue intValue] >= [rightValue intValue];
	else if([operator isEqualToString:@"<="]) retval = [leftValue intValue] <= [rightValue intValue];
	else if([operator isEqualToString:@">"]) retval = [leftValue intValue] > [rightValue intValue];
	else if([operator isEqualToString:@"<"]) retval = [leftValue intValue] < [rightValue intValue];
	else
	{
		DBGLOG(@"Invalid IF-operator in %@: '%@' --> %@ %@ %@",
			   novel.currentState.script.localPath, command.string, leftValue, operator, rightValue);
		retval = NO;
	}
	
	DBGLOG(@"IF: Result: %@", MTStringWithBool(retval));
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


#pragma mark - Debug
#if TARGET_IPHONE_SIMULATOR
- (void)debugLog:(NSString *)string
{
	Command *dbgcmd = [[Command alloc] init];
	dbgcmd.text = [NSString stringWithFormat:@"@>>DBG: %@", string];
	dbgcmd.script = novel.currentState.script;
	[delegate interpreter:self processTEXT:dbgcmd];
	[dbgcmd release];
}
#endif

@end
