//
//  SoundEngine.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-11.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "SoundEngine.h"
#import "SoundChannel.h"
#import "Novel.h"

@interface SoundEngine()
- (SoundChannel *)channel:(VNSoundChannelID)cid;
@end

@implementation SoundEngine

- (id)initWithNovel:(Novel *)novel_
{
	if((self = [super init]))
	{
		novel = [novel_ retain];
		channels = [[NSMutableArray alloc] initWithCapacity:_VNSoundChannelCount];
		for(VNSoundChannelID i = 0; i < _VNSoundChannelCount; i++) [channels addObject:[NSNull null]];
	}
	
	return self;
}

- (void)playSound:(NSString *)name onChannel:(VNSoundChannelID)channelID loops:(NSInteger)loops
{
	SoundChannel *channel = [self channel:channelID];
	if([name length] == 0) return; //Don't play nothing (yes, this happens; I've had both @"" and nil)
	else if([name isEqualToString:@"~"]) [channel stop];
	else
	{
		MTLog(@"Playing Sound '%@'...", name);
		channel.loops = loops;
		
		NSData *data = [novel contentsOfResource:[@"sound" stringByAppendingPathComponent:name]];
		NSError *error = [channel loadData:data];
		if(error == nil) [channel play];
		else
			MTLog(@"Audio Loading Error: %@", error);
	}
}

- (void)stopChannel:(VNSoundChannelID)channel
{
	[[self channel:channel] stop];
}

- (NSInteger)volumeForChannel:(VNSoundChannelID)channel
{
	return [[self channel:channel] volume];
}

- (void)setVolume:(NSInteger)volume forChannel:(VNSoundChannelID)channel
{
	[[self channel:channel] setVolume:volume];
}

- (SoundChannel *)channel:(VNSoundChannelID)cid
{
	SoundChannel *channel = [channels objectAtIndex:cid];
	if((NSNull *)channel == [NSNull null])
	{
		channel = [[SoundChannel alloc] init];
		[channels replaceObjectAtIndex:cid withObject:channel];
		[channel release];
	}
	
	return channel;
}

@end
