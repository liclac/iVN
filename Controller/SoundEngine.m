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
	/*AVAudioPlayer *player = (music ? musicPlayer : soundPlayer);
	[player stop];
	[player release];
	
	if([filename isEqualToString:@"~"])
	{
		if(music) musicPlayer = nil;
		else soundPlayer = nil;
	}
	else
	{
		NSError *error = nil;
		NSString *path = [novel relativeToAbsolutePath:[@"sound" stringByAppendingPathComponent:filename]];
		AVAudioPlayer *newPlayer =  [[AVAudioPlayer alloc]
									 initWithContentsOfURL:[NSURL fileURLWithPath:path]
									 error:&error];
		if(music)
		{
			novel.currentState.music = filename;
			newPlayer.volume = musicVolume;
			musicPlayer = newPlayer;
		}
		else
		{
			[newPlayer setNumberOfLoops:loops];
			newPlayer.volume = soundVolume;
			soundPlayer = newPlayer;
		}
		
		if(error != nil) MTLog(@"%@ -> %@:\n%@", filename, path, error);
		else
		{
			MTLog(@"Playing %@ %@", (music ? @"Music" : @"Sound"), filename);
			[newPlayer play];
		}
	}*/
	
	SoundChannel *channel = [self channel:channelID];
	if([name isEqualToString:@"~"]) [channel stop];
	else
	{
		channel.loops = loops;
		
		NSData *data = [novel contentsOfResource:[@"sound" stringByAppendingPathComponent:name]];
		NSError *error = [channel loadData:data];
		if(error == nil) [channel play];
		else MTLog(@"Audio Loading Error: %@", error);
		
		/*if(NO)
		{
			//TODO: Add Archive Loading
		}
		else
		{
			NSString *path = [novel relativeToAbsolutePath:[@"sound" stringByAppendingPathComponent:name]];
			MTLog(@"Playing Audio at %@...", path);
			NSError *error = [channel loadPath:path];
			if(error == nil) [channel play];
			else MTLog(@"Audio Loading Error: %@", error);
		}*/
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
