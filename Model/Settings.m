//
//  Settings.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Settings.h"
#import "SynthesizeSingleton.h"

@implementation Settings
@synthesize controlMode, displayMode;

SYNTHESIZE_SINGLETON_FOR_CLASS(Settings)

- (id)init
{
	if((self = [super init]))
	{
		[self load];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save)
													 name:UIApplicationDidEnterBackgroundNotification object:nil];
	}
	
	return self;
}

- (void)save
{
	[[NSUserDefaults standardUserDefaults] setInteger:controlMode forKey:@"controlMode"];
	[[NSUserDefaults standardUserDefaults] setInteger:displayMode forKey:@"displayMode"];
}

- (void)load
{
	controlMode = (VNControlMode)[[NSUserDefaults standardUserDefaults] integerForKey:@"controlMode"];
	displayMode = (VNDisplayMode)[[NSUserDefaults standardUserDefaults] integerForKey:@"displayMode"];
}

@end
