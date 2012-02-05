//
//  Command.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Command.h"
#import "Script.h"
#import "Novel.h"
#import "State.h"
#import "Variable.h"

@interface Command(Private)
- (void)loadFromString:(NSString *)str;
- (NSString *)replaceVariablesInString:(NSString *)string;
@end

@implementation Command
@synthesize script, type, string, text, endPosition;

- (id)initWithString:(NSString *)str script:(Script *)script_
{
    if((self = [super init]))
	{
		[self loadFromString:str];
		script = script_;
    }
    
    return self;
}

/**
 * Private function that performs the actual initialization, since it's bad practice to this much work in init.
 */
- (void)loadFromString:(NSString *)str
{
	str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	/*
	 * --->
	 * ---> WARNING:
	 * --->
	 * This is only called from within the initializer, which means that assigning properties (eg. self.whatever = value) isn't safe.
	 * Instead use "whatever = [value retain]" or similar
	 */
	
	
	
	
	
	
	
	/**
	 * Split the parameter string into components separated by whitespaces.
	 * It's generally good practice to use the whitespace character set instead of @" ",
	 * otherwise you may have trouble with encodings in some (extremely) rare cases.
	 * And the character set version is more readable.
	 */
	NSArray *components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if([components count] < 1) //If there are 0 items, the array is either nil or otherwise invalid, and then so is the command
	{
		/*
		 * Assign the UNKNOWN type to have the command skipped when reading but still kept in the command list to avoid messing up
		 * save positions.
		 * Technically unnecessary as int variables (enums are named ints, in case you didn't know) default to 0,
		 * and UNKNOWN is the first element in the enum, meaning it will ALSO defaults to 0.
		 * But it's generally good practice to assign it anyways for readability
		 */
		type = VNCommandTypeUNKNOWN;
		return;
	}
	
	
	/*
	 * --> Process Command Name
	 */
	NSString *name = [[components objectAtIndex:0] uppercaseString];	//Uppercase just because "BGLOAD" looks cooler than "bgload" ;)
	
	// "Translate" the text name into a more manageable - and faster managed - VNCommandType.
	// VNCommandType is typedef:ed from an enum in the header in case you missed it.
	if([name length] < 1) type = VNCommandTypeUNKNOWN;
	else if([name isEqualToString:@"BGLOAD"]) type = VNCommandTypeBGLOAD;
	else if([name isEqualToString:@"SETIMG"]) type = VNCommandTypeSETIMG;
	else if([name isEqualToString:@"SOUND"]) type = VNCommandTypeSOUND;
	else if([name isEqualToString:@"MUSIC"]) type = VNCommandTypeMUSIC;
	else if([name isEqualToString:@"TEXT"]) type = VNCommandTypeTEXT;
	else if([name isEqualToString:@"CHOICE"]) type = VNCommandTypeCHOICE;
	else if([name isEqualToString:@"SETVAR"]) type = VNCommandTypeSETVAR;
	else if([name isEqualToString:@"GSETVAR"]) type = VNCommandTypeGSETVAR;
	else if([name isEqualToString:@"IF"]) type = VNCommandTypeIF;
	else if([name isEqualToString:@"FI"]) type = VNCommandTypeFI;
	else if([name isEqualToString:@"JUMP"]) type = VNCommandTypeJUMP;
	else if([name isEqualToString:@"DELAY"]) type = VNCommandTypeDELAY;
	else if([name isEqualToString:@"RANDOM"]) type = VNCommandTypeRANDOM;
	else if([name isEqualToString:@"SKIP"]) type = VNCommandTypeSKIP;
	else if([name isEqualToString:@"ENDSCRIPT"]) type = VNCommandTypeENDSCRIPT;
	else if([name isEqualToString:@"LABEL"]) type = VNCommandTypeLABEL;
	else if([name isEqualToString:@"GOTO"]) type = VNCommandTypeGOTO;
	else if([name isEqualToString:@"CLEARTEXT"]) type = VNCommandTypeCLEARTEXT;
	else
	{
		MTALog(@"Unrecognized Command: %@ (%@)", name, str); //Print a Debug Message that's a fatal error in a debug environment
		type = VNCommandTypeUNKNOWN; //See a little bit higher up for an explanation on this one
	}
	
	
	
	/*
	 * --> Process Parameters
	 */
	// Save the text starting after the name ([name length]) and also skip the whitespace following it (+1).
	// Leave the text set to nil if there's no text though.
	if([str length] > [name length]+1)
	{
		text = [[str substringFromIndex:[name length]+1] retain];
	}
	
	if([components count] > 1) //Otherwise, but only if there are any parameters other than the command name...
	{
		/*
		 * ...assign all the components except for the command name to parameters.
		 * Range starts at 1 (the command name is object 0) and goes to the end.
		 */
		parameters = [[components subarrayWithRange:NSMakeRange(1, [components count]-1)] retain];
	}
	
	//Save the original string for debugging purposes
	string = [str retain];
}

- (id)parameterAtIndex:(NSInteger)index defaultValue:(id)defval
{
	return [self parameterAtIndex:index defaultValue:defval maybeVariable:NO];
}

- (id)parameterAtIndex:(NSInteger)index defaultValue:(id)defval maybeVariable:(BOOL)mv
{
	if([parameters count] > index)
	{
		NSString *value = [parameters objectAtIndex:index];
		if(mv)
		{
			Variable *var = [script.novel variableForName:value];
			return (var ? [var objectValue] : value);
		}
		else return value;
	}
	else return defval;
}

- (NSInteger)parameterCount
{
	return [parameters count];
}

- (NSString *)text
{
	return [self replaceVariablesInString:text];
}

- (NSString *)replaceVariablesInString:(NSString *)string_
{
	NSMutableString *str = [[NSMutableString alloc] init];
	NSScanner *scanner = [[NSScanner alloc] initWithString:string_];
	NSString *foundString;
	
	[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
	NSCharacterSet *endSet = [NSCharacterSet characterSetWithCharactersInString:@" :"];
	while(![scanner isAtEnd])
	{
		if([scanner scanUpToString:@"$" intoString:&foundString])
		{
			[str appendString:foundString];
		}
		if(![scanner isAtEnd])
		{
			[scanner scanString:@"$" intoString:nil];
			foundString = @""; //scanUpToString doesn't modify foundString if no characters are scanned
							   //[scanner scanUpToString:@" " intoString:&foundString];
			[scanner scanUpToCharactersFromSet:endSet intoString:&foundString];
			
			id value = [script.novel variableForName:foundString];
			if(value != nil) [str appendString:[value stringValue]];
			else [str appendString:foundString];
		}
	}
	
	NSString *retval = [str copy];
	[str release];
	return [retval autorelease];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Command: '%@'>", string];
}

@end
