//
//  SoundChannel.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-13.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "SoundChannel.h"

#define kVNSoundMaxVolume 16

@implementation SoundChannel
@synthesize volume, loops;

- (void)setVolume:(NSInteger)volume_
{
	volume = volume_;
	player.volume = volume/kVNSoundMaxVolume;
}

- (void)setLoops:(NSInteger)loops_
{
	loops = loops_;
	player.numberOfLoops = loops-1;
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
	player.volume = volume/kVNSoundMaxVolume;
	player.numberOfLoops = loops-1;
	[player play];
}

- (void)stop
{
	[player stop];
	[player release];
	player = nil;
}

@end
