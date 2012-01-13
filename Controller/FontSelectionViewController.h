//
//  FontSelectionViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-12.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameMenuViewController;

@interface FontSelectionViewController : UITableViewController
{
	NSArray *defaultFonts, *defaultSubtitles, *fonts;
	BOOL autoscrolling;
}

@property (nonatomic, assign) GameMenuViewController *delegate;

- (void)actionCancel;
- (void)actionDefault;
- (void)saveFont:(NSString *)font;

@end
