//
//  LoadingBackgroundView.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-02.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "LoadingBackgroundView.h"

//static CGFloat strokeComponents[] = {1, 1, 1, 1};

@implementation LoadingBackgroundView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
	{
		self.clipsToBounds = NO;
		self.layer.masksToBounds = NO;
		self.backgroundColor = [UIColor clearColor];
		
		path = CGPathCreateMutable();
		CGPathMoveToPoint(path, NULL, self.bounds.size.width/2, 0);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width - 10, 0);
		CGPathAddArcToPoint(path, NULL, self.bounds.size.width, 0, self.bounds.size.width, 10, 10);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height - 10);
		CGPathAddArcToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height, self.bounds.size.width - 10, self.bounds.size.height, 10);
		CGPathAddLineToPoint(path, NULL, 10, self.bounds.size.height);
		CGPathAddArcToPoint(path, NULL, 0, self.bounds.size.height, 0, self.bounds.size.height - 10, 10);
		CGPathAddLineToPoint(path, NULL, 0, 10);
		CGPathAddArcToPoint(path, NULL, 0, 0, 10, 0, 10);
		CGPathAddLineToPoint(path, NULL, self.bounds.size.width/2, 0);
		
		shapeLayer = [[CAShapeLayer layer] retain];
		shapeLayer.path = path;
		shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
		shapeLayer.fillColor = [UIColor clearColor].CGColor;
		shapeLayer.lineCap = kCALineCapRound;
		shapeLayer.lineWidth = 3;
		shapeLayer.strokeEnd = 0;
		[self.layer addSublayer:shapeLayer];
		
		CGPathRelease(path);
		[self spawnAnimation];
    }
    return self;
}

- (void)spawnAnimation
{
	CAAnimationGroup *group = [CAAnimationGroup animation];
	
	CAKeyframeAnimation *startAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
	startAnim.values = [NSArray arrayWithObjects:MTFloatNumber(0), MTFloatNumber(0), MTFloatNumber(1), nil];
	CAKeyframeAnimation *endAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	endAnim.values = [NSArray arrayWithObjects:MTFloatNumber(0), MTFloatNumber(1), MTFloatNumber(1), nil];
	
	group.animations = [NSArray arrayWithObjects:startAnim, endAnim, nil];
	group.delegate = self;
	group.duration = 5;
	[shapeLayer addAnimation:group forKey:@"group"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	[self spawnAnimation];
}

@end
