//
//  SettingsViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SettingsViewController.h"
#import "Novel.h"
#import "Settings.h"

@implementation SettingsViewController
@synthesize controlModeStandardButton;
@synthesize controlModeClassicButton;
@synthesize descriptionLabel;

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
	
	[self actionSelectControlMode:([Settings sharedSettings].controlMode == VNControlModeStandard ?
								   controlModeStandardButton : controlModeClassicButton)];
}

- (void)viewDidUnload
{
    [self setControlModeStandardButton:nil];
    [self setControlModeClassicButton:nil];
    [self setDescriptionLabel:nil];
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
    [controlModeStandardButton release];
    [controlModeClassicButton release];
    [descriptionLabel release];
    [super dealloc];
}

- (IBAction)actionSelectControlMode:(id)sender
{
	if(sender == controlModeClassicButton)
	{
		descriptionLabel.text = @"Classic Mode attempts to emulate the feel of the original VNDS by showing you a keypad which replace most of the touch commands.";
		controlModeClassicButton.selected = YES;
		controlModeStandardButton.selected = NO;
	}
	else
	{
		descriptionLabel.text = @"Standard Mode is the default control mode, which uses only touches.";
		controlModeClassicButton.selected = NO;
		controlModeStandardButton.selected = YES;
	}
}

- (IBAction)actionSave:(id)sender
{
	[Settings sharedSettings].controlMode = (controlModeStandardButton.selected ? VNControlModeStandard : VNControlModeClassic);
	[self dismissModalViewControllerAnimated:YES];
}

@end
