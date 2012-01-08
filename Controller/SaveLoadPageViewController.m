//
//  SaveLoadPageViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SaveLoadPageViewController.h"
#import "SaveLoadSlotButton.h"
#import "Novel.h"

@implementation SaveLoadPageViewController
@synthesize buttonSlot1;
@synthesize buttonSlot2;
@synthesize buttonSlot3;
@synthesize buttonSlot4;
@synthesize buttonSlot5;
@synthesize buttonSlot6;
@synthesize labelSlot1;
@synthesize labelSlot2;
@synthesize labelSlot3;
@synthesize labelSlot4;
@synthesize labelSlot5;
@synthesize labelSlot6;
@synthesize novel, slotOffset;
@synthesize delegate, loading;

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
	
	buttonSlot1.novel = novel;
	buttonSlot2.novel = novel;
	buttonSlot3.novel = novel;
	buttonSlot4.novel = novel;
	buttonSlot5.novel = novel;
	buttonSlot6.novel = novel;
	
	buttonSlot1.slot = slotOffset;
	buttonSlot2.slot = slotOffset+1;
	buttonSlot3.slot = slotOffset+2;
	buttonSlot4.slot = slotOffset+3;
	buttonSlot5.slot = slotOffset+4;
	buttonSlot6.slot = slotOffset+5;
	
	buttonSlot1.loading = loading;
	buttonSlot2.loading = loading;
	buttonSlot3.loading = loading;
	buttonSlot4.loading = loading;
	buttonSlot5.loading = loading;
	buttonSlot6.loading = loading;
	
	[buttonSlot1 updateContents];
	[buttonSlot2 updateContents];
	[buttonSlot3 updateContents];
	[buttonSlot4 updateContents];
	[buttonSlot5 updateContents];
	[buttonSlot6 updateContents];
}

- (void)viewDidUnload
{
    [self setButtonSlot1:nil];
    [self setButtonSlot2:nil];
    [self setButtonSlot3:nil];
    [self setButtonSlot4:nil];
    [self setButtonSlot5:nil];
    [self setButtonSlot6:nil];
	[self setLabelSlot1:nil];
	[self setLabelSlot2:nil];
	[self setLabelSlot3:nil];
	[self setLabelSlot4:nil];
	[self setLabelSlot5:nil];
	[self setLabelSlot6:nil];
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
    [buttonSlot1 release];
    [buttonSlot2 release];
    [buttonSlot3 release];
    [buttonSlot4 release];
    [buttonSlot5 release];
    [buttonSlot6 release];
	[labelSlot1 release];
	[labelSlot2 release];
	[labelSlot3 release];
	[labelSlot4 release];
	[labelSlot5 release];
	[labelSlot6 release];
    [super dealloc];
}

- (IBAction)actionHighlightSlot:(id)sender
{
	[delegate saveLoadPage:self didHighlightSlot:[sender slot]];
}

@end
