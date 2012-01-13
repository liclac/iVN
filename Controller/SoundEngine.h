//
//  SoundEngine.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-11.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Novel;
@class Archive;

typedef enum
{
	VNSoundChannelMusic,
	VNSoundChannelSound,
	_VNSoundChannelCount
} VNSoundChannelID;

@interface SoundEngine : NSObject
{
	Novel *novel;
	Archive *archive;
	NSMutableArray *channels;
}

- (id)initWithNovel:(Novel *)novel;

- (void)playSound:(NSString *)name onChannel:(VNSoundChannelID)channel loops:(NSInteger)loops;
- (void)stopChannel:(VNSoundChannelID)channel;
- (NSInteger)volumeForChannel:(VNSoundChannelID)channel;
- (void)setVolume:(NSInteger)volume forChannel:(VNSoundChannelID)channel;

@end
