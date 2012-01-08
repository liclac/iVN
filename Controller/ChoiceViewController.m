//
//  ChoiceViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "ChoiceViewController.h"
#import "Novel.h"
#import "State.h"
#import "Variable.h"

@implementation ChoiceViewController
@synthesize options, textView, novel, delegate;

- (id)initWithOptions:(NSArray *)iOptions textView:(UIView *)iTextView
				novel:(Novel *)iNovel delegate:(id<ChoiceDelegate>)iDelegate
{
    self = [super init];
    if (self)
	{
		options = [iOptions retain];
		textView = [iTextView retain];
		novel = [iNovel retain];
		delegate = iDelegate;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (void)show
{
	MTALog(@"This is an abstract method that must be overridden in subclasses");
}

- (void)hide
{
	MTALog(@"This is an abstract method that must be overridden in subclasses");
}

- (void)actionSelectIndex:(NSInteger)index
{
	Variable *var = [[Variable alloc] initWithKey:@"selected" value:[NSNumber numberWithInteger:index]];
	[novel.currentState.vars setObject:var forKey:var.key];
	[var release];
	[delegate choiceClosed:self];
	
	[self hide];
}

@end
