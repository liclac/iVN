//
//  ChoiceViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceDelegate.h"
@class Novel;

@interface ChoiceViewController : UIViewController
{
	NSArray *options;
	UIView *textView;
	Novel *novel;
	
	id<ChoiceDelegate> delegate;
}

@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) UIView *textView;
@property (nonatomic, retain) Novel *novel;
@property (nonatomic, assign) id<ChoiceDelegate> delegate;

- (id)initWithOptions:(NSArray *)options textView:(UIView *)textView novel:(Novel *)novel delegate:(id<ChoiceDelegate>)delegate;
- (void)show;
- (void)hide;
- (void)actionSelectIndex:(NSInteger)index;

@end
