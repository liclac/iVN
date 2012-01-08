//
//  NovelInfo.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Novel;

/**
 * This class stores data on a Novel that is not functionality-related to keep the code clean.
 * 
 * This class only acts as a container, and thus has no functions.
 */

@interface NovelInfo : NSObject
{
	Novel *novel;					//The Novel to read data from
	NSString *title;				//User-readable title for the novel
	UIImage *icon, *thumbnail;		//Lazy-loaded images
	BOOL iconValid, thumbnailValid;	//Werther the source files for the images are readable
	BOOL iPhoneEnabled,				//Does the novel include iPhone 2G/3G/3GS-specific files?
			iPadEnabled,			//Does the novel include iPad-specific files?
			iPhone4Enabled;			//Does the novel include iPhone 4/4S (Retina)-specific files?
}

@property (nonatomic, assign) Novel *novel; //Don't retain the parent object
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *icon, *thumbnail;
@property (nonatomic, assign) BOOL iPhoneEnabled, iPadEnabled, iPhone4Enabled;

- (id)initWithNovel:(Novel *)novel;
- (void)unload;

@end
