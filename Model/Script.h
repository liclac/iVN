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
 * It manages a list of commands and label lookup table by name.
 */

@interface Script : NSObject
{
	NSString *localPath;			//Source File Path relative to the novel root
	NSMutableArray *commands;		//All Commands in the file, stored in Command objects
	NSMutableDictionary *labels;	//All Labels in the file, keys are NSStrings with the name, values are NSNumbers with the line nr.
}

@property (nonatomic, readonly) NSString *localPath;
@property (nonatomic, retain) NSMutableArray *commands;
@property (nonatomic, retain) NSMutableDictionary *labels;

- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding localPath:(NSString *)localPath;
- (void)unload;

@end
