//
//  GameMenuViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-25.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameViewController;

@interface GameMenuViewController : UIViewController <UIPopoverControllerDelegate>
{
	GameViewController *gameVC;
	UILabel *fontSizeLabel;
	UILabel *soundVolumeLabel;
	UILabel *musicVolumeLabel;
	UISlider *fontSizeSlider;
	UIButton *fontButton;
	UISlider *soundVolumeSlider;
	UISlider *musicVolumeSlider;
	int *fontSize, *soundVolume, *musicVolume;
	NSString **font;
	
	UIPopoverController *padPopoverController;
}

@property (nonatomic, retain) GameViewController *gameVC;
@property (nonatomic, retain) IBOutlet UILabel *fontSizeLabel;
@property (nonatomic, retain) IBOutlet UIButton *fontButton;
@property (nonatomic, retain) IBOutlet UILabel *soundVolumeLabel;
@property (nonatomic, retain) IBOutlet UILabel *musicVolumeLabel;
@property (nonatomic, retain) IBOutlet UISlider *fontSizeSlider;
@property (nonatomic, retain) IBOutlet UISlider *soundVolumeSlider;
@property (nonatomic, retain) IBOutlet UISlider *musicVolumeSlider;

@property (nonatomic, assign) int *fontSize, *soundVolume, *musicVolume;
@property (nonatomic, assign) NSString **font;

@property (nonatomic, retain) UIPopoverController *padPopoverController;

- (IBAction)actionChangeFontSize:(id)sender;
- (IBAction)actionChangeFont:(id)sender;
- (IBAction)actionChangeSoundVolume:(id)sender;
- (IBAction)actionChangeMusicVolume:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionExit:(id)sender;
- (void)fontSelectionDismissedWithNewFont:(NSString *)fontName;

@end
