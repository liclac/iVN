//
//  MainMenuViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadingViewController;

@interface MainMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CollectionDelegate>
{
	UITableView *table;
	UIImageView *thumbnailImageView;
	UIButton *playButton;
	UIButton *settingsButton;
	
	LoadingViewController *loadingVC;
	BOOL hasAppeared;
}
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) LoadingViewController *loadingVC;

- (IBAction)actionPlay:(id)sender;
- (IBAction)actionSettings:(id)sender;
- (void)updateCollection;

@end
