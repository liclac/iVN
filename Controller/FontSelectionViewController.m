//
//  FontSelectionViewController.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-12.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "FontSelectionViewController.h"
#import "GameMenuViewController.h"


@implementation FontSelectionViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
	
	fonts = [[[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] retain];
	defaultFonts = [[NSArray alloc] initWithObjects:
					@"Sazanami Gothic",
					@"Helvetica",
					@"OsakaMono",
					//@"Arial",
					nil];
	defaultSubtitles = [[NSArray alloc] initWithObjects:
						@"VNDS Classic Font",
						@"iOS Standard Font",
						@"Standard Japanese Font",
						//@"Windows Standard Font",
						nil];
	
	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				 target:self action:@selector(actionCancel)];
	self.navigationItem.leftBarButtonItem = closeButton;
	[closeButton release];
	
	UIBarButtonItem *defaultButton = [[UIBarButtonItem alloc] initWithTitle:@"Default" style:UIBarButtonItemStyleBordered
																	 target:self action:@selector(actionDefault)];
	self.navigationItem.rightBarButtonItem = defaultButton;
	[defaultButton release];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)actionCancel
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)actionDefault
{
	self.tableView.userInteractionEnabled = NO;
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
	/*self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;*/
	autoscrolling = YES;
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
								animated:YES scrollPosition:UITableViewScrollPositionTop];
	//[self performSelector:@selector(saveFont:) withObject:@"Sazanami Gothic" afterDelay:0.2];
}

- (void)saveFont:(NSString *)font
{
	[delegate fontSelectionDismissedWithNewFont:font];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (section == 0 ? [defaultFonts count] : [fonts count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:floor([UIFont systemFontSize]*0.75)];
    }
	
	NSArray *source = (indexPath.section == 0 ? defaultFonts : fonts);
	NSString *font = [source objectAtIndex:indexPath.row];
	cell.textLabel.text = font;
	cell.textLabel.font = [UIFont fontWithName:font size:[UIFont systemFontSize]];
	cell.detailTextLabel.text = (indexPath.section == 0 ? [defaultSubtitles objectAtIndex:indexPath.row] : nil);
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return (section == 0 ? @"Recommended Fonts" : @"All Fonts");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self saveFont:[[tableView cellForRowAtIndexPath:indexPath] textLabel].text];
}


#pragma mark - Scroll View Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if(!autoscrolling) return;
	[self.tableView deselectAnimated:YES];
	[self performSelector:@selector(saveFont:) withObject:@"Sazanami Gothic" afterDelay:0.5];
}

@end
