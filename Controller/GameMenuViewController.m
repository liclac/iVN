//
//  GameMenuViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-25.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "GameMenuViewController.h"
#import "GameViewController.h"

@implementation GameMenuViewController
@synthesize gameVC;

@synthesize fontSizeLabel;
@synthesize soundVolumeLabel, musicVolumeLabel;

@synthesize fontSizeSlider, fontSegment;
@synthesize soundVolumeSlider, musicVolumeSlider;

@synthesize fontSize, soundVolume, musicVolume, font;
@synthesize padPopoverController;

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
	
	fontSizeSlider.value = *fontSize;
	soundVolumeSlider.value = *soundVolume;
	musicVolumeSlider.value = *musicVolume;
	fontSegment.selectedSegmentIndex = *font;
	
	fontSizeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([fontSizeSlider value])];
	soundVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([soundVolumeSlider value])];
	musicVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([musicVolumeSlider value])];
}

- (CGSize)contentSizeForViewInPopover
{
	return CGSizeMake(480, self.view.bounds.size.height);
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

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)actionChangeFontSize:(id)sender
{
	fontSizeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([fontSizeSlider value])];
	*fontSize = (int)round([fontSizeSlider value]);
	[gameVC actionSettingsChanged];
}

- (IBAction)actionChangeFont:(id)sender
{
	*font = [sender selectedSegmentIndex];
	[gameVC actionSettingsChanged];
}

- (IBAction)actionChangeSoundVolume:(id)sender
{
	soundVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([soundVolumeSlider value])];
	*soundVolume = (int)round([soundVolumeSlider value]);
	[gameVC actionSettingsChanged];
}

- (IBAction)actionChangeMusicVolume:(id)sender
{
	musicVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([musicVolumeSlider value])];
	*musicVolume = (int)round([musicVolumeSlider value]);
	[gameVC actionSettingsChanged];
}

- (IBAction)actionBack:(id)sender
{
	[gameVC actionSettingsClosed];
	if(padPopoverController == nil) [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)actionExit:(id)sender
{
	if(padPopoverController == nil) [self dismissModalViewControllerAnimated:NO];
	else [padPopoverController dismissPopoverAnimated:NO];
	[gameVC actionExit];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self actionBack:nil];
}

@end
