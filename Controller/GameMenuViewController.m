//
//  GameMenuViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-25.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "GameMenuViewController.h"
#import "GameViewController.h"
#import "FontSelectionViewController.h"

@implementation GameMenuViewController
@synthesize gameVC;

@synthesize fontSizeLabel;
@synthesize soundVolumeLabel, musicVolumeLabel;

@synthesize fontSizeSlider, fontButton;
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
	[fontButton setTitle:*font forState:UIControlStateNormal];
	[fontButton.titleLabel setFont:[UIFont fontWithName:*font size:[UIFont systemFontSize]]];
	
	fontSizeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([fontSizeSlider value])];
	soundVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([soundVolumeSlider value])];
	musicVolumeLabel.text = [NSString stringWithFormat:@"%02d", (NSInteger)round([musicVolumeSlider value])];
}

- (void)actionFeedback:(id)sender
{
	[TestFlight openFeedbackView];
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
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;//UIInterfaceOrientationIsLandscape(interfaceOrientation);
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
	FontSelectionViewController *vc = [[FontSelectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
	vc.delegate = self;
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	//[self.navigationController pushViewController:vc animated:YES];
	[self presentModalViewController:vc animated:YES createNavigationController:YES];
	[vc release];
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

- (void)fontSelectionDismissedWithNewFont:(NSString *)fontName
{
	//Retaining/Releasing like this mutes analysis warnings about leaks
	[fontName performSelector:@selector(retain)];
	[*font performSelector:@selector(release)];
	*font = fontName;
	[fontButton setTitle:fontName forState:UIControlStateNormal];
	[fontButton.titleLabel setFont:[UIFont fontWithName:fontName size:[UIFont systemFontSize]]];
	[gameVC actionSettingsChanged];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self actionBack:nil];
}

@end
