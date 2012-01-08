//
//  LoadingBackgroundView.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-02.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSpawnDelay 30

@interface LoadingBackgroundView : UIView
{
	CAShapeLayer *shapeLayer;
	CGMutablePathRef path;
}

- (void)spawnAnimation;

@end
