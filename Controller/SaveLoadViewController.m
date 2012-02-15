//
//  SaveLoadViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SaveLoadViewController.h"
#import "SaveLoadPageViewController.h"
#import "Save.h"
#import "SaveImage.h"
#import "Novel.h"
#import "LoadingViewController.h"

@implementation SaveLoadViewController
@synthesize novel, si, selectedSlot, mode;
@synthesize scrollView;
@synthesize saveLoadButton;
@synthesize delegate;

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
	
	pages = [[NSMutableArray alloc] initWithCapacity:kSaveLoadPageCount];
	for(NSInteger i = 0; i < kSaveLoadPageCount; i++)
	{
		SaveLoadPageViewController *page = [[SaveLoadPageViewController alloc] init];
		page.slotOffset = i*6; //6 = The number of slots on a page
		page.novel = novel;
		page.delegate = self;
		page.loading = (mode == VNSaveLoadModeLoad);
		page.view.frame = CGRectMake(i*scrollView.frame.size.width,
									 0,
									 scrollView.frame.size.width,
									 scrollView.frame.size.height);
		[scrollView addSubview:page.view];
		[pages addObject:page];
		[page release];
	}
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*kSaveLoadPageCount, scrollView.frame.size.height);
	
	[saveLoadButton setTitle:(mode == VNSaveLoadModeLoad ? @"Load" : @"Save") forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
	[self setSaveLoadButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)saveLoadPage:(SaveLoadPageViewController *)page didHighlightSlot:(NSInteger)slot
{
	selectedSlot = slot;
	MTLog(@"%d", selectedSlot);
}

- (void)dealloc {
    [scrollView release];
	[saveLoadButton release];
    [super dealloc];
}

- (IBAction)actionPreviousPage:(id)sender
{
	NSInteger page = round(scrollView.contentOffset.x/scrollView.frame.size.width);
	MTLog(@"%d", page);
	//CGFloat offset = scrollView.contentOffset.y - scrollView.frame.size.width;
	CGFloat offset = (page*scrollView.frame.size.width) - scrollView.frame.size.width;
	if(offset < 0) offset = 0;
	[scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (IBAction)actionNextPage:(id)sender
{
	NSInteger page = round(scrollView.contentOffset.x/scrollView.frame.size.width);
	MTLog(@"%d", page);
	//CGFloat offset = scrollView.contentOffset.y - scrollView.frame.size.width;
	CGFloat offset = (page*scrollView.frame.size.width) + scrollView.frame.size.width;
	if(offset > scrollView.frame.size.width*(kSaveLoadPageCount-1)) offset = scrollView.frame.size.width*(kSaveLoadPageCount-1);
	[scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (IBAction)actionCancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionSaveLoad:(id)sender
{
	Save *save = [novel.saves objectForKey:[NSNumber numberWithInt:selectedSlot]];
	if(mode == VNSaveLoadModeLoad)
	{
		loadingVC = [[LoadingViewController alloc] init];
		loadingVC.view.frame = self.view.bounds; //Prevent the view from getting stuck in a corner on the iPad
		[self.view addSubview:loadingVC.view];
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
			//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
			[save loadWithScriptInterpreter:si];
			[loadingVC release];
			[self dismissModalViewControllerAnimated:YES];
		});
	}
	else
	{
		SaveImage *image = [[SaveImage alloc] initWithSave:save];
		[image createFromView:[delegate viewForSaveThumbnail]];
		save.image = image;
		[image release];
		[save saveWithScriptInterpreter:si];
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
