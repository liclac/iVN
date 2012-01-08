//
//  SpriteView.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sprite;

/**
 * A Sprite View manages a single on-screen Sprite.
 * The view's frame should be set to it's superview's bounds, since it calculates the origin point of it's image
 * relative to it's own bounds.
 */
@interface SpriteView : UIView
{
	Sprite *sprite;
	CGSize scale;
}

@property (nonatomic, retain) Sprite *sprite;
@property (nonatomic, assign) CGSize scale;

- (id)initWithFrame:(CGRect)frame sprite:(Sprite *)sprite scale:(CGSize)scale;
- (void)unload;

@end
