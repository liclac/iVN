//
//  SaveLoadSlotButton.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Novel, SaveImage;

#define kSLButtonTimestampHeight 10
#define kSLButtonImageWidth 64
#define kSLButtonImageHeight 48

@interface SaveLoadSlotButton : UIButton
{
	Novel *novel;
	NSInteger slot;
	BOOL animating, loading;
	UILabel *dateLabel;
	
	SaveImage *img;
}

@property (nonatomic, retain) Novel *novel;
@property (nonatomic, assign) NSInteger slot;
@property (nonatomic, assign) BOOL animating, loading;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@property (nonatomic, retain) SaveImage *img;

- (void)updateContents;

@end
