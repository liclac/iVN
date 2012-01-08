//
//  NovelInfo.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "NovelInfo.h"
#import "Novel.h"

@implementation NovelInfo
@synthesize novel, title, icon, thumbnail, iPhoneEnabled, iPadEnabled, iPhone4Enabled;

- (id)initWithNovel:(Novel *)theNovel
{
	if((self = [super init]))
	{
		novel = theNovel;
		
		//Assume that the source files are valid until they are proven not to be
		iconValid = YES;
		thumbnailValid = YES;
		
		//Release the images on low memory warnings
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unload)
													 name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	
	return self;
}

- (NSString *)title
{
	if(title == nil)
	{
		NSString *file = [[NSString alloc] initWithContentsOfFile:[novel relativeToAbsolutePath:@"info.txt"]
														 encoding:NSUTF8StringEncoding error:nil];
		NSArray *lines = [file componentsSeparatedByString:@"\n"];
		for(NSString *line in lines)
		{
			if([line hasPrefix:@"title="])
			{
				title = [[line substringFromIndex:6] retain]; //6 = The length of "title="
				break;
			}
			else if([line isEqualToString:@"iPhoneEnabled=true"]) iPhoneEnabled = YES;
			else if([line isEqualToString:@"iPadEnabled=true"]) iPadEnabled = YES;
			else if([line isEqualToString:@"iPhone4Enabled=true"]) iPhone4Enabled = YES;
		}
		
		[file release];
	}
	
	return title;
}

- (UIImage *)icon
{
	if(icon == nil && iconValid)
	{
		icon = [[UIImage alloc] initWithContentsOfFile:[novel relativeToAbsolutePath:@"icon.png"]];
		if(icon == nil) iconValid = NO;
	}
	
	return icon;
}

- (UIImage *)thumbnail
{
	if(thumbnail == nil && thumbnailValid)
	{
		thumbnail = [[UIImage alloc] initWithContentsOfFile:[novel relativeToAbsolutePath:@"thumbnail.png"]];
		if(thumbnail == nil) thumbnailValid = NO;
	}
	
	return thumbnail;
}

- (void)unload
{
	self.icon = nil;
	self.thumbnail = nil;
}

@end
