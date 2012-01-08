//
//  Settings.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Control Mode to use.
 * VNControlModeStandard	= Completely new Touch-based interface
 * VNControlModeClassic		= DS-style button-based interface
 */
typedef enum VNControlMode
{
	VNControlModeStandard,
	VNControlModeClassic
} VNControlMode;

/**
 * Display Mode to use.
 * VNDisplayModeNVL			= NVL-mode - A Fullscreen box containing the past few lines displayed (like Fate/Stay Night)
 * VNDisplayModeADV			= ADV-mode - A smaller box at the bottom of the screen showing only the last line (like Clannad)
 */
typedef enum VNDisplayMode
{
	VNDisplayModeNVL,
	VNDisplayModeADV
} VNDisplayMode;

/**
 * A Settings Object stores user settings.
 * 
 * This class only acts as a container, and thus has no functions.
 */
@interface Settings : NSObject <NSCopying>
{
	VNControlMode controlMode;	//Used Control Mode
	VNDisplayMode displayMode;	//Used Display Mode
}

@property (nonatomic, assign) VNControlMode controlMode;
@property (nonatomic, assign) VNDisplayMode displayMode;

+ (Settings *)sharedSettings;
- (void)save;
- (void)load;

@end
