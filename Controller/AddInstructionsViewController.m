//
//  AddInstructionsViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-02-08.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "AddInstructionsViewController.h"
#import "MainMenuViewController.h"

@implementation AddInstructionsViewController
@synthesize scrollView, pageControl, pages;
@synthesize mainMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSArray *sortedPages = [pages sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2){
		if([obj1 tag] == [obj2 tag]) return NSOrderedSame;
		else return ([obj1 tag] < [obj2 tag] ? NSOrderedAscending : NSOrderedDescending);
	}];
	CGFloat xPos = 0;
	for(UIView *view in sortedPages)
	{
		view.frame = CGRectMake(xPos, 0, scrollView.frame.size.width, scrollView.frame.size.height);
		[scrollView addSubview:view];
		xPos += scrollView.frame.size.width;
	}
	
	scrollView.contentSize = CGSizeMake(xPos, scrollView.frame.size.height);
	pageControl.numberOfPages = [sortedPages count];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)actionClose:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionRefresh:(id)sender
{
	[mainMenu updateCollectionWithView:self.view];
}

- (IBAction)actionPage:(UIPageControl *)sender
{
	[scrollView scrollRectToVisible:CGRectMake(sender.currentPage*scrollView.frame.size.width, 0,
											   scrollView.frame.size.width, scrollView.frame.size.height)
						   animated:YES];
	pageControlUsed = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
	if(pageControlUsed) return; //Don't update if the page control triggered it, it'll cause flicker
	
	pageControl.currentPage = floor((scrollView_.contentOffset.x - scrollView_.frame.size.width/2)/scrollView_.frame.size.width) + 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlUsed = NO;
}

@end
