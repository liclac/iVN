//
//  UIWebView+BufferFunctions.m
//  iVN
//
//  Created by Johannes Ekberg on 2012-01-03.
//  Copyright (c) 2012 MacaroniCode Software. All rights reserved.
//

#import "UIWebView+BufferFunctions.h"

@implementation UIWebView (BufferFunctions)

- (void)addLine:(NSString *)string_
{
	NSString *string = ([string_ length] > 0 ? [string_ stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""] : @" ");
	MTLog(@"%@: '%@'", string, [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__addLine(\"%@\")", string]]);
}

- (void)clearBuffer
{
	[self stringByEvaluatingJavaScriptFromString:@"__clearBuffer()"];
}

- (void)setFontSize:(NSInteger)size
{
	MTLog(@"'%@'", [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__setFontSize(%d)", size]]);
}

- (void)setFont:(VNFontOption)font
{
	MTLog(@"'%@'", [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"__setFont(%d)", font]]);
}

@end
