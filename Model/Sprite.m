//
//  Sprite.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite
@synthesize path, image, point;

- (id)initWithPath:(NSString *)path_ data:(NSData *)data point:(CGPoint)point_
{
	if((self = [super init]))
	{
		path = [path_ retain];
		point = point_;
		image = [[UIImage alloc] initWithData:data];
	}
	
	return self;
}

- (void)unload
{
	self.image = nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	Sprite *copy = [[Sprite allocWithZone:zone] init];
	copy.path = [[self.path copyWithZone:zone] autorelease];
	copy.point = CGPointMake(self.point.x, self.point.y);
	
	return copy;
}

@end
