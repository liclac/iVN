//
//  ClassicModeViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassicModeViewController : UIViewController
{
	
	UIButton *buttonUp;
	UIButton *buttonDown;
	UIButton *buttonLeft;
	UIButton *buttonRight;
	UIButton *buttonA;
	UIButton *buttonB;
	UIButton *buttonY;
	UIButton *buttonX;
	
	NSArray *allButtons;
}
@property (nonatomic, retain) IBOutlet UIButton *buttonUp;
@property (nonatomic, retain) IBOutlet UIButton *buttonDown;
@property (nonatomic, retain) IBOutlet UIButton *buttonLeft;
@property (nonatomic, retain) IBOutlet UIButton *buttonRight;
@property (nonatomic, retain) IBOutlet UIButton *buttonA;
@property (nonatomic, retain) IBOutlet UIButton *buttonB;
@property (nonatomic, retain) IBOutlet UIButton *buttonY;
@property (nonatomic, retain) IBOutlet UIButton *buttonX;

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *allButtons;

- (IBAction)actionHighlightButton:(UIButton *)sender;
- (IBAction)actionUnhighlightButton:(UIButton *)sender;
- (IBAction)actionButtonPressed:(UIButton *)sender;

@end
