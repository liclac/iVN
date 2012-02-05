//
//  StandardChoiceViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "StandardChoiceViewController.h"

@implementation StandardChoiceViewController
@synthesize scrollView, frame;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	MTLog(@"%@", options);
	
	self.view.frame = frame;
	
	standardBG = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	selectedBG = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	selectedIndex = -1;
	
	buttons = [[NSMutableArray alloc] initWithCapacity:[options count]];
	for(NSString *option in options)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = CGRectMake(kStandardChoiceButtonSpacing,
								  -kStandardChoiceButtonHeight,
								  scrollView.frame.size.width - (kStandardChoiceButtonSpacing*2),
								  kStandardChoiceButtonHeight);
		button.titleLabel.textColor = [UIColor blackColor];
		//[button setBackgroundToGlossyRectOfColor:standardBG withBorder:YES forState:UIControlStateNormal];
		[button setTitle:option forState:UIControlStateNormal];
		[button setTitleColor:standardBG forState:UIControlStateNormal];
		[button setTitleColor:selectedBG forState:UIControlStateSelected];
		button.alpha = 0;
		//button.backgroundColor = [UIColor blueColor];
		[button addTarget:self action:@selector(actionSelect:) forControlEvents:UIControlEventTouchUpInside];
		[buttons addObject:button];
		[scrollView addSubview:button];
		MTLog(@"%@", button.titleLabel.text);
	}
	
	MTLog(@"%@", buttons);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}

#pragma mark Actions
- (void)show
{
	MTMark();
	NSTimeInterval time = kStandardChoiceAnimationTime; //Time left of the animation
	CGFloat offset = kStandardChoiceButtonSpacing; //Top offset for the next button
	NSTimeInterval delay = 0.5; //Delay for the next button's animation
	
	for(UIButton *button in buttons)
	{
		[UIView animateWithDuration:kStandardChoiceAnimationTime*[buttons count] delay:0.1 options:0
						 animations:^{button.alpha = 1;}
						 completion:NULL];
		
		[UIView animateWithDuration:time delay:delay options:0
						 animations:^
		 {
			 button.frame = CGRectMake(button.frame.origin.x, offset, button.frame.size.width, button.frame.size.height);
		 }
						 completion:NULL];
		
		offset += kStandardChoiceButtonHeight+kStandardChoiceButtonSpacing;
		time += kStandardChoiceAnimationTime;
		delay += kStandardChoiceAnimationDelay;
	}
	
	[UIView animateWithDuration:time animations:^{textView.alpha = 0;}];
	
	[self performSelector:@selector(retain)]; //Prevent self from getting deallocated
}

- (void)hide
{
	MTMark();
	//Decrease this and count it backwards to let the first button move out first
	NSTimeInterval time = kStandardChoiceAnimationTime*[buttons count];
	NSTimeInterval delay = kStandardChoiceAnimationDelay*[buttons count];
	BOOL first = YES;
	
	[UIView animateWithDuration:time animations:^{textView.alpha = 1;}];
	
	void (^completionBlock)(BOOL b) = ^(BOOL b)
	{
		[self.view removeFromSuperview];
		[self performSelector:@selector(release)];
	};
	
	for(UIButton *button in buttons)
	{
		[UIView animateWithDuration:kStandardChoiceAnimationTime*[buttons count] delay:0.5 options:0
						 animations:^{button.alpha = 0;}
						 completion:NULL];
		[UIView animateWithDuration:time delay:delay options:0
						 animations:^
		 {
			 button.frame = CGRectMake(button.frame.origin.x, 0, button.frame.size.width, button.frame.size.height);
		 }
						 completion:(first ? completionBlock : NULL)];
		
		time -= kStandardChoiceAnimationTime;
		delay -= kStandardChoiceAnimationDelay;
		first = NO;
	}
}

- (void)actionSelect:(UIButton *)sender
{
	NSInteger index = [buttons indexOfObject:sender];
	if(index == selectedIndex)
	{
		[self actionSelectIndex:index+1]; //Start counting the buttons at 1 instead of 0
	}
	else
	{
		[sender setSelected:YES];
		if(selectedIndex != -1) [[buttons objectAtIndex:selectedIndex] setSelected:NO];
		selectedIndex = index;
	}
}

@end
