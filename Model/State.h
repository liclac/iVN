//
//  State.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Script;

/**
 * A State in the game execution.
 * Used both for drawing the graphics and for saving.
 * 
 * This class only acts as a container, and thus has no functions.
 */

@interface State : NSObject <NSCopying>
{
	Script *script;					//Currently executing Script
	NSInteger position;				//Line number of the next command to execute
	NSInteger textSkip;				//How many text commands have been executed (for some reason this is what's saved to disk)
	NSString *music, *background;	//Currently playing music and current background image
	NSMutableArray *sprites;		//All Sprites currently onscreen
	NSMutableDictionary *vars;		//All Local Variables
}

@property (nonatomic, retain) Script *script;
@property (nonatomic, assign) NSInteger position, textSkip;
@property (nonatomic, retain) NSString *music, *background;
@property (nonatomic, readonly) NSMutableArray *sprites;
@property (nonatomic, readonly) NSMutableDictionary *vars;

- (void)reset;

@end
