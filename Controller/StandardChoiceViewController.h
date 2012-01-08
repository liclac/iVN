//
//  StandardChoiceViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "ChoiceViewController.h"

#define kStandardChoiceButtonSpacing 10
#define kStandardChoiceButtonHeight 40
#define kStandardChoiceAnimationTime 0.1
#define kStandardChoiceAnimationDelay 0.05

@interface StandardChoiceViewController : ChoiceViewController
{
	UIScrollView *scrollView;
	
	NSMutableArray *buttons;
	NSInteger selectedIndex;
	UIColor *standardBG, *selectedBG;
	
	CGRect frame;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGRect frame;

- (void)actionSelect:(UIButton *)sender;

@end
