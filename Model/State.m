//
//  State.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "State.h"
#import "Script.h"

@implementation State
@synthesize script, position, textSkip, music, background, sprites, vars;

- (id)init
{
	if((self = [super init]))
	{
		sprites = [[NSMutableArray alloc] init];
		vars = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)reset
{
	[script unload], self.script = nil;
	position = 0;
	textSkip = 0;
	self.music = nil;
	self.background = nil;
	[sprites removeAllObjects];
}

- (id)copyWithZone:(NSZone *)zone
{
	State *copy = [[State allocWithZone:zone] init];
	copy.script = script;
	copy.position = position;
	copy.textSkip = textSkip;
	copy.music = [[music copyWithZone:zone] autorelease];
	copy.background = [[background copyWithZone:zone] autorelease];
	[copy.sprites setArray:sprites];
	[copy.vars setDictionary:vars];
	
	return copy;
}

@end
