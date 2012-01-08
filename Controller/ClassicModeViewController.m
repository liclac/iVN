//
//  ClassicModeViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "ClassicModeViewController.h"

@implementation ClassicModeViewController
@synthesize buttonUp;
@synthesize buttonDown;
@synthesize buttonLeft;
@synthesize buttonRight;
@synthesize buttonA;
@synthesize buttonB;
@synthesize buttonY;
@synthesize buttonX;
@synthesize allButtons;

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
	
	//Align the text properly (why can't this be done in Interface Builder?)
	buttonUp.titleLabel.textAlignment = UITextAlignmentCenter;
	buttonDown.titleLabel.textAlignment = UITextAlignmentCenter;
	buttonLeft.titleLabel.textAlignment = UITextAlignmentLeft;
	buttonRight.titleLabel.textAlignment = UITextAlignmentRight;
	
	buttonA.titleLabel.textAlignment = UITextAlignmentRight;
	buttonB.titleLabel.textAlignment = UITextAlignmentCenter;
	buttonY.titleLabel.textAlignment = UITextAlignmentLeft;
	buttonX.titleLabel.textAlignment = UITextAlignmentCenter;
}

- (void)viewDidUnload
{
    [self setButtonUp:nil];
    [self setButtonDown:nil];
    [self setButtonLeft:nil];
    [self setButtonRight:nil];
    [self setButtonA:nil];
    [self setButtonB:nil];
    [self setButtonY:nil];
    [self setButtonX:nil];
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
    [buttonUp release];
    [buttonDown release];
    [buttonLeft release];
    [buttonRight release];
    [buttonA release];
    [buttonB release];
    [buttonY release];
    [buttonX release];
    [super dealloc];
}

- (IBAction)actionHighlightButton:(UIButton *)sender
{
	sender.alpha = 0.8;
}

- (IBAction)actionUnhighlightButton:(UIButton *)sender
{
	sender.alpha = 0.5;
}

- (IBAction)actionButtonPressed:(UIButton *)sender
{
	MTLog(@"%@", sender.titleLabel.text);
}
@end
