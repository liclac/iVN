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

- (void)collection:(Collection *)collection willUnzipFile:(NSString *)filename
{
	MTLog(@"%@", filename);
	dispatch_async(dispatch_get_main_queue(), ^{
		loadingVC.subtitleLabel.text = [NSString stringWithFormat:@"Decompressing file '%@'...", filename];
		[loadingVC.view setNeedsDisplay];
	});
}

- (void)collection:(Collection *)collection willReadSoundFromNovel:(NSString *)novel
{
	MTLog(@"%@", novel);
	dispatch_async(dispatch_get_main_queue(), ^{
		loadingVC.subtitleLabel.text = [NSString stringWithFormat:@"Decompressing sound from '%@'...", novel];
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
