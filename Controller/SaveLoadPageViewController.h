//
//  SaveLoadPageViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveLoadPageDelegate.h"

@class SaveLoadSlotButton;
@class Novel;

@interface SaveLoadPageViewController : UIViewController
{
	SaveLoadSlotButton *buttonSlot1;
	SaveLoadSlotButton *buttonSlot2;
	SaveLoadSlotButton *buttonSlot3;
	SaveLoadSlotButton *buttonSlot4;
	SaveLoadSlotButton *buttonSlot5;
	SaveLoadSlotButton *buttonSlot6;
	UILabel *labelSlot1;
	UILabel *labelSlot2;
	UILabel *labelSlot3;
	UILabel *labelSlot4;
	UILabel *labelSlot5;
	UILabel *labelSlot6;
	
	Novel *novel;
	NSInteger slotOffset;
	
	id<SaveLoadPageDelegate> delegate;
	BOOL loading;
}

@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot1;
@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot2;
@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot3;
@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot4;
@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot5;
@property (nonatomic, retain) IBOutlet SaveLoadSlotButton *buttonSlot6;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot1;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot2;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot3;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot4;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot5;
@property (nonatomic, retain) IBOutlet UILabel *labelSlot6;

@property (nonatomic, retain) Novel *novel;
@property (nonatomic, assign) NSInteger slotOffset;

@property (nonatomic, assign) id<SaveLoadPageDelegate> delegate;
@property (nonatomic, assign) BOOL loading;

- (IBAction)actionHighlightSlot:(id)sender;

@end
