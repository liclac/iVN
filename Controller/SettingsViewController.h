//
//  SettingsViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Novel;

@interface SettingsViewController : UIViewController
{
	UIButton *controlModeStandardButton;
	UIButton *controlModeClassicButton;
	UILabel *descriptionLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *controlModeStandardButton;
@property (nonatomic, retain) IBOutlet UIButton *controlModeClassicButton;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;

- (IBAction)actionSelectControlMode:(id)sender;
- (IBAction)actionSave:(id)sender;

@end
