//
//  Script.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A Script object handles a single .scr-file in a novel.
 * It manages a (lazy-loaded) list of commands and label lookup table by name.
 */

@interface Script : NSObject
{
	NSString *path, *absPath;		//Source File Path; path is relative, absPath is absolute and should not be saved
	NSMutableArray *commands;		//All Commands in the file, stored in Command objects
	NSMutableDictionary *labels;	//All Labels in the file, keys are NSStrings with the name, values are NSNumbers with the line nr.
}

@property (nonatomic, readonly) NSString *path, *absPath;
@property (nonatomic, retain) NSMutableArray *commands;
@property (nonatomic, retain) NSMutableDictionary *labels;

- (id)initWithContentsOfFile:(NSString *)path absPath:(NSString *)absPath;
- (void)unload;

@end
