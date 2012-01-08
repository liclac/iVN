//
//  Sprite.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A Sprite represents a single foreground image on the screen.
 * 
 * This class only acts as a container, and thus has no functions.
 */

@interface Sprite : NSObject <NSCopying>
{
	NSString *path, *absPath;		//Path to the source image file. 'path' is relative, 'absPath' is absolute
	UIImage *image;					//Lazy-loaded image to represent; released on low memory warnings
	CGPoint point;					//Point to draw at
	BOOL valid;						//Werther the source file is valid or not; if not, don't try to load it
}

@property (nonatomic, retain) NSString *path, *absPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) CGPoint point;

- (id)initWithPath:(NSString *)path absPath:(NSString *)absPath point:(CGPoint)point;
- (void)unload;

@end
