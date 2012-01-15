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
	//NOTE: We must encode the line with UTF-8 before sending it to JS-land.
	//      Not doing this will break Japanese text, such as that in the beginning of Saya no Uta (s01.scr)
	NSString *utf8string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__addLine(\"%@\")", utf8string]];
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
