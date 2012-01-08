//
//  TextPaneView.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-22.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "TextPaneView.h"

/*@interface TextPaneLine : NSObject
{
	CGGlyph *glyphs;
	CGSize *advances;
	CGRect *bounds;
	CFIndex count;
	NSString *string;
}

@property (nonatomic, assign) CGGlyph *glyphs;
@property (nonatomic, assign) CGSize *advances;
@property (nonatomic, assign) CGRect *bounds;
@property (nonatomic, assign) CFIndex count;
@property (nonatomic, retain) NSString *string;

@end
@implementation TextPaneLine
@synthesize glyphs, advances, bounds, count, string;

- (void)dealloc
{
	free(glyphs);
	free(advances);
	[super dealloc];
}

@end*/

@implementation TextPaneView
@synthesize offset_, fontSize;

- (void)addLine:(NSString *)line
{
	if(textBuffer == nil) textBuffer = [[NSMutableArray alloc] initWithCapacity:kBufferSize];
	//if(strings == nil) strings = [[NSMutableArray alloc] initWithCapacity:kBufferSize];
	
	if([textBuffer count] >= kBufferSize) { [textBuffer removeObjectAtIndex:0];/* [strings removeObjectAtIndex:0];*/ }
	[textBuffer addObject:line];
	//[strings addObject:line];
	
	if(ctFont != NULL) CFRelease(ctFont);
	ctFont = CTFontCreateWithName(CFSTR("Helvetica"), 19, NULL);
	
	if(string != NULL) CFRelease(string), string = NULL;
	string = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	for(NSString *line in textBuffer)
	{
		CFAttributedStringReplaceString(string, CFRangeMake(CFAttributedStringGetLength(string), 0),
										(CFStringRef)[NSString stringWithFormat:@"%@\n", line]);
										//(CFStringRef)line);
	}
	CFAttributedStringSetAttribute(string, CFRangeMake(0, CFAttributedStringGetLength(string)), kCTFontAttributeName, ctFont);
	[self setNeedsDisplay];
}

- (void)clearBuffer
{
	[textBuffer removeAllObjects];
	//[strings removeAllObjects];
}

- (void)drawRect:(CGRect)rect
{
	if(string == NULL) return;
}

@end
