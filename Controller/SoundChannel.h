//
//  SoundChannel.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-13.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundChannel : NSObject
{
	AVAudioPlayer *player;
	NSInteger volume, loops;
}

@property (nonatomic, assign) NSInteger volume, loops;

- (NSError *)loadPath:(NSString *)path;
- (NSError *)loadData:(NSData *)data;
- (void)play;
- (void)stop;

@end
