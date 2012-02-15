//
//  SoundChannel.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-13.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "SoundChannel.h"

#define kVNSoundMaxVolume 16.0

@interface SoundChannel()
- (void)setupPlayer;
@end

@implementation SoundChannel
@synthesize volume, loops;

- (void)setVolume:(NSInteger)volume_
{
	volume = volume_;
	[self setupPlayer];
}

- (void)setLoops:(NSInteger)loops_
{
	loops = loops_;
	[self setupPlayer];
}

- (NSError *)loadPath:(NSString *)path
{
	[self stop];
	NSError *error = nil;
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	
	return error;
}

- (NSError *)loadData:(NSData *)data
{
	[self stop];
	NSError *error = nil;
	player = [[AVAudioPlayer alloc] initWithData:data error:&error];
	
	return error;
}

- (void)play
{
	[self setupPlayer];
	[player play];
}

- (void)stop
{
	[player stop];
	[player release];
	player = nil;
}

- (void)setupPlayer
{
	player.volume = ((float)volume)/kVNSoundMaxVolume;
	player.numberOfLoops = loops;
}

@end
