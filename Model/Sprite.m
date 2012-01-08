//
//  Sprite.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite
@synthesize path, absPath, image, point;

- (id)initWithPath:(NSString *)aPath absPath:(NSString *)abPath point:(CGPoint)aPoint
{
	if((self = [super init]))
	{
		path = [aPath retain];
		absPath = [abPath retain];
		point = aPoint;
		valid = YES; //Assume that the source file is valid until it's proven not to be
		MTLog(@"%@ %@", path, absPath);
	}
	
	return self;
}

- (void)unload
{
	self.image = nil;
}

- (UIImage *)image
{
	//Lazy-load the image
	if(image == nil && valid)
	{
		image = [[UIImage alloc] initWithContentsOfFile:absPath];
		if(image == nil) valid = NO;
	}
	
	return image;
}

- (id)copyWithZone:(NSZone *)zone
{
	Sprite *copy = [[Sprite allocWithZone:zone] init];
	copy.path = [[self.path copyWithZone:zone] autorelease];
	copy.point = CGPointMake(self.point.x, self.point.y);
	
	return copy;
}

@end
