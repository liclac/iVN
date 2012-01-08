//
//  TextPaneView.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define kBufferSize 500 //Same as VNDS's Buffer Size
#define kPaddingX 10
#define kPaddingY 0

@interface TextPaneView : UIView
{
	NSInteger offset_;
	CGFloat fontSize;
	CTFontRef ctFont;
	CGFontRef cgFont;
	
	NSMutableArray *textBuffer;//, *strings;
	CFMutableAttributedStringRef string;
}

@property (nonatomic, assign) NSInteger offset_;
@property (nonatomic, assign) CGFloat fontSize;

- (void)addLine:(NSString *)line;
- (void)clearBuffer;

@end
