//
//  SaveLoadSlotButton.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SaveLoadSlotButton.h"
#import "Novel.h"
#import "Save.h"
#import "SaveImage.h"

@implementation SaveLoadSlotButton
@synthesize novel, slot, animating, loading, dateLabel, img;

- (void)updateContents
{
	Save *save = [[novel.saves objectForKey:[NSNumber numberWithInteger:slot]] retain];
	img = [[SaveImage alloc] initWithSave:save];
	
	if(!save.exists)
	{
		[self setTitle:@"Empty" forState:UIControlStateNormal];
		self.dateLabel.text = nil;
		self.enabled = !loading;
	}
	else
	{
		if(save.date == nil) [save loadDate];
		[self setTitle:[NSString stringWithFormat:@"%d", slot+1] forState:UIControlStateNormal];
		
		[img loadFromFile];
		[self setImage:img.img forState:UIControlStateNormal];
		
		self.dateLabel.text = save.date;
		self.enabled = YES;
	}
	
	[save release];
}

@end
