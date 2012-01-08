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
@synthesize soundVolumeLabel;
@synthesize musicVolumeLabel;
@synthesize fontSizeSlider;
@synthesize soundVolumeSlider;
@synthesize musicVolumeSlider;
@synthesize fontSize, soundVolume, musicVolume;
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
	soundVolumeSlider.value = *soundVolume*soundVolumeSlider.maximumValue;
	musicVolumeSlider.value = *musicVolume*musicVolumeSlider.maximumValue;
	
	fontSizeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[fontSizeSlider value]];
	soundVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[soundVolumeSlider value]];
	musicVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[musicVolumeSlider value]];
}

- (CGSize)contentSizeForViewInPopover
{
	return CGSizeMake(480, self.view.bounds.size.height);
}

- (void)viewDidUnload
{
    [self setFontSizeLabel:nil];
    [self setFontSizeSlider:nil];
    [self setSoundVolumeLabel:nil];
    [self setMusicVolumeLabel:nil];
    [self setSoundVolumeSlider:nil];
	[self setMusicVolumeSlider:nil];
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
    [fontSizeLabel release];
    [fontSizeSlider release];
    [soundVolumeLabel release];
    [musicVolumeLabel release];
    [soundVolumeSlider release];
	[musicVolumeSlider release];
    [super dealloc];
}

- (IBAction)actionChangeFontSize:(id)sender
{
	fontSizeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[fontSizeSlider value]];
	*fontSize = [fontSizeSlider value];
}

- (IBAction)actionChangeSoundVolume:(id)sender
{
	soundVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[soundVolumeSlider value]];
	*soundVolume = [soundVolumeSlider value]/[soundVolumeSlider maximumValue];
}

- (IBAction)actionChangeMusicVolume:(id)sender
{
	musicVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)[musicVolumeSlider value]];
	*musicVolume = [musicVolumeSlider value]/[musicVolumeSlider maximumValue];
}

- (IBAction)actionBack:(id)sender
{
	[gameVC actionMenuClosed];
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
