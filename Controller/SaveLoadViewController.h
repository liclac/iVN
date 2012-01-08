//
//  SaveLoadViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveLoadDelegate.h"
#import "SaveLoadPageDelegate.h"
@class Novel;
@class ScriptInterpreter;
@class LoadingViewController;

#define kSaveLoadPageCount 3

typedef enum VNSaveLoadMode
{
	VNSaveLoadModeSave,
	VNSaveLoadModeLoad
} VNSaveLoadMode;

@interface SaveLoadViewController : UIViewController <UIScrollViewDelegate,SaveLoadPageDelegate>
{
	Novel *novel;
	ScriptInterpreter *si;
	NSInteger selectedSlot;
	VNSaveLoadMode mode;
	NSMutableArray *pages;
	
	UIScrollView *scrollView;
	UIButton *saveLoadButton;
	
	id<SaveLoadDelegate> delegate;
	
	LoadingViewController *loadingVC;
}

@property (nonatomic, retain) Novel *novel;
@property (nonatomic, retain) ScriptInterpreter *si;
@property (nonatomic, assign) NSInteger selectedSlot;
@property (nonatomic, assign) VNSaveLoadMode mode;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *saveLoadButton;

@property (nonatomic, retain) id<SaveLoadDelegate> delegate;

- (IBAction)actionPreviousPage:(id)sender;
- (IBAction)actionNextPage:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSaveLoad:(id)sender;

@end
