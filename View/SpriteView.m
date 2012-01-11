//
//  SpriteView.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SpriteView.h"
#import "Sprite.h"

@implementation SpriteView
@synthesize sprite, scale;

- (id)initWithFrame:(CGRect)rect sprite:(Sprite *)aSprite scale:(CGFloat)scale_
{
    if((self = [super initWithFrame:rect]))
	{
		sprite = [aSprite retain];
		scale = scale_;
		
		self.alpha = 0;
		self.clipsToBounds = NO;
		self.opaque = NO;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect
{
	//[sprite.image drawAtPoint:sprite.point];
	CGSize imageSize = sprite.image.size;
	CGRect imageRect = CGRectMake(floor(sprite.point.x*scale),
								  floor(sprite.point.y*scale),
								  floor(imageSize.width*scale),
								  floor(imageSize.height*scale));
	[sprite.image drawInRect:imageRect];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView animateWithDuration:duration delay:wait
						options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{self.alpha = 0;}
					 completion:^(BOOL b){if(b)[self unload];}];
}

- (void)unload
{
	[self removeFromSuperview];
	[sprite unload];
}

- (void)dealloc
{
	[sprite release];
	[super dealloc];
}

@end
