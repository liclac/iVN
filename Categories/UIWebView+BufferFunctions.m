//
//  UIWebView+BufferFunctions.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-03.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "UIWebView+BufferFunctions.h"

@implementation UIWebView (BufferFunctions)

- (void)addLine:(NSString *)string
{
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__addLine(\"%@\")", string]];
}

- (void)clearBuffer
{
	[self stringByEvaluatingJavaScriptFromString:@"__clearBuffer()"];
}

- (void)setFontSize:(NSInteger)size
{
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__setFontSize(%d)", size]];
}

- (void)setFont:(NSString *)font
{
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__setFont(\"%@\")", font]];
}

@end
