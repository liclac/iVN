//
//  Script.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Script.h"
#import "Command.h"

@interface Script(Private)
- (void)loadFromFile;
@end

@implementation Script
@synthesize path, absPath, commands, labels;

- (id)initWithContentsOfFile:(NSString *)aPath absPath:(NSString *)theAbsPath
{
    if ((self = [super init]))
	{
		path = [aPath retain];
		absPath = [theAbsPath retain];
    }
    
    return self;
}

- (NSMutableArray *)commands
{
	if(commands == nil) [self loadFromFile];
	return commands;
}

- (NSMutableDictionary *)labels
{
	if(labels == nil) [self loadFromFile];
	return labels;
}

- (void)loadFromFile
{
	/**
	 * Load the contents of the script file, split the lines and create command objects from them.
	 * Note the use of [NSCharacterSet newlineCharacterSet] rather than @"\n": this way you don't have to worry about
	 * "\r" characters lying about. Plus it's good practice to use Character Sets rather than string literals where it makes sense.
	 */
	NSString *contents = [NSString stringWithContentsOfFile:absPath encoding:NSUTF8StringEncoding error:NULL];
	NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	commands = [[NSMutableArray alloc] initWithCapacity:[lines count]];
	labels = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *unclosedIfs = [[NSMutableArray alloc] init];
	for(NSString *line in lines)
	{
		//Create a Command object with the current line
		Command *command = [[Command alloc] initWithString:line];
		[commands addObject:command];
		
		//Assign end points to IF commands
		if(command.type == VNCommandTypeIF)
			[unclosedIfs addObject:command]; //Save a reference so we can close it when we find it's end point
		else if(command.type == VNCommandTypeFI)
		{
			[[unclosedIfs lastObject] setEndPosition:[commands count] - 1];
			[unclosedIfs removeLastObject];
		}
		else if(command.type == VNCommandTypeLABEL)
			[labels setObject:[NSNumber numberWithInteger:[commands count]-1] forKey:[command.parameters objectAtIndex:0]];
		
		[command release];
	}
	
	MTAssert([unclosedIfs count] == 0, @"Unclosed IF in file %@", path);
	[unclosedIfs release];
}

- (void)unload
{
	self.commands = nil;
	self.labels = nil;
}

@end
