//
//  LoadingViewController.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-25.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
{
	UILabel *subtitleLabel;
	UIProgressView *progressBar;
}

@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;

@end
