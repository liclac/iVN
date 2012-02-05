//
//  Script.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Script.h"
#import "Command.h"
#import "Novel.h"

@interface Script(Private)
- (void)loadFromString:(NSString *)string;
@end

@implementation Script
@synthesize novel, localPath, commands, labels;

- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding localPath:(NSString *)localPath_ novel:(Novel *)novel_
{
	if((self = [super init]))
	{
		novel = novel_;
		localPath = [localPath_ retain];
		
		NSString *string = [[NSString alloc] initWithData:data encoding:encoding];
		MTLog(@"%@:\n%@", localPath, string);
		[self loadFromString:string];
		[string release];
	}
	
	return self;
}

- (void)loadFromString:(NSString *)string
{
	NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	commands = [[NSMutableArray alloc] initWithCapacity:[lines count]];
	labels = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *unclosedIfs = [[NSMutableArray alloc] init];
	for(NSString *line in lines)
	{
		//Create a Command object with the current line
		Command *command = [[Command alloc] initWithString:line script:self];
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
			[labels setObject:[NSNumber numberWithInteger:[commands count]-1]
					   forKey:[command parameterAtIndex:0 defaultValue:nil]];
		
		[command release];
	}
	
	MTAssert([unclosedIfs count] == 0, @"Unclosed IF in file %@", localPath);
	[unclosedIfs release];
}

- (void)unload
{
	self.commands = nil;
	self.labels = nil;
}

@end
