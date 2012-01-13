//
//  UIWebView+BufferFunctions.h
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-03.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (BufferFunctions)

- (void)addLine:(NSString *)string;
- (void)clearBuffer;
- (void)setFontSize:(NSInteger)size;
- (void)setFont:(NSString *)font;

@end
