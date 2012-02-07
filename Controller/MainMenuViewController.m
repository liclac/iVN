//
//  MainMenuViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Novel.h"
#import "NovelInfo.h"
#import "GameViewController.h"
#import "SettingsViewController.h"
#import "LoadingViewController.h"

#import "CTools.h"

@implementation MainMenuViewController
@synthesize table;
@synthesize thumbnailImageView;
@synthesize playButton;
@synthesize settingsButton;
@synthesize loadingVC;

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
	
	loadingVC = [[LoadingViewController alloc] init];
	loadingVC.view.frame = self.view.bounds;
	[self.view addSubview:loadingVC.view];
}

- (void)viewDidAppear:(BOOL)animated
{
	if(hasAppeared) return;
	
	[self updateCollection];
	hasAppeared = YES;
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setThumbnailImageView:nil];
    [self setPlayButton:nil];
    [self setSettingsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [table release];
    [thumbnailImageView release];
    [playButton release];
    [settingsButton release];
    [super dealloc];
}


#pragma mark - Actions
- (IBAction)actionPlay:(id)sender
{
	Novel *novel = [[Collection sharedCollection].novels objectAtIndex:[table indexPathForSelectedRow].row];
	[TestFlight addCustomEnvironmentInformation:novel.info.title forKey:@"novel"];
	GameViewController *vc = [[GameViewController alloc] init];
	vc.novel = novel;
	vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	[self presentModalViewController:vc animated:YES];
	
	[table deselectAnimated:YES];
	
	[vc release];
}

- (IBAction)actionSettings:(id)sender
{
	SettingsViewController *vc = [[SettingsViewController alloc] init];
	[self presentModalViewController:vc animated:YES];
	[vc release];
}


#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[Collection sharedCollection] novels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellID = @"_CellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	
	Novel *novel = [[[Collection sharedCollection] novels] objectAtIndex:indexPath.row];
	cell.textLabel.text = novel.info.title;
	cell.imageView.image = novel.info.icon;
	
	MTLog(@"%d = %@", indexPath.row, novel.info.title);
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	playButton.enabled = YES;
	
	Novel *novel = [[Collection sharedCollection].novels objectAtIndex:indexPath.row];
	thumbnailImageView.image = novel.info.thumbnail;
}


#pragma mark - Collection
- (void)updateCollection
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
				   ^{[[Collection sharedCollection] loadCollectionWithDelegate:self];});
}

- (void)collection:(Collection *)collection willUnzipFile:(NSString *)filename count:(NSInteger)count
{
	[self collection:collection willUnzipFileNumber:0 outOf:count from:filename];
}

- (void)collection:(Collection *)collection willUnzipFileNumber:(NSInteger)number outOf:(NSInteger)total from:(NSString *)from
{
	MTLog(@"%d/%d", number, total);
	dispatch_async(dispatch_get_main_queue(), ^{
		float progress = (float)number/(float)total;
		NSInteger padding = numdigits(total);
		
		loadingVC.subtitleLabel.text = [NSString stringWithFormat:@"Decompressing file %*d/%-*d from %@... (%d%%)",
										padding, number, padding, total, [from lastPathComponent],
										(NSInteger)(progress*100)];
		loadingVC.progressBar.hidden = NO;
		loadingVC.progressBar.progress = progress;
		[loadingVC.view setNeedsDisplay];
	});
}

- (void)collection:(Collection *)collection willStartCleaningUpExtractionOfArchive:(NSString *)filename
{
	MTLog(@"Cleaning %@", filename);
	dispatch_async(dispatch_get_main_queue(), ^{
		loadingVC.subtitleLabel.text = [NSString stringWithFormat:@"Finishing extraction of %@...", filename];
		loadingVC.progressBar.progress = 1;
		[loadingVC.view setNeedsDisplay];
	});
}

- (void)collectionDidFinishUpdating:(Collection *)collection
{
	MTMark();
	dispatch_async(dispatch_get_main_queue(), ^{
		[table reloadData];
		[loadingVC.view removeFromSuperview];
		MTSafeRelease(loadingVC);
	});
}

@end
