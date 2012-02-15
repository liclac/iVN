//
//  AddInstructionsViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-02-08.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainMenuViewController;

@interface AddInstructionsViewController : UIViewController <UIScrollViewDelegate>
{
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	NSArray *pages;
	
	BOOL pageControlUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray *pages;

@property (nonatomic, assign) MainMenuViewController *mainMenu;

- (IBAction)actionClose:(id)sender;
- (IBAction)actionRefresh:(id)sender;
- (IBAction)actionPage:(UIPageControl *)sender;

@end
