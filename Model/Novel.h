//
//  Novel.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScriptInterpreterDelegate.h"
@class NovelInfo;
@class State;
@class Settings;
@class Script;
@class Variable;

/**
 * Main Model object for Novels.
 * A Novel object represents a single title, such as Tsukihime or Fate/Stay Night, that has been loaded into the application.
 * 
 * All data that is not functionality-related, such as Title and Icon, is kept in a separate NovelInfo object stored in the 'info' ivar.
 * This class also handles loading of resources and saves, and translation from relative to absolute paths;
 */

@interface Novel : NSObject <ScriptInterpreterDelegate>
{
	NSString *directory, *path;			//Directory all paths are relative to, and an absolute path to there
	NovelInfo *info;					//Holds data that are not relevant to functionality, such as title and icons
	
	NSMutableDictionary *saves;			//Keys are NSNumbers with the save number (-1 = Global), Values are Save objects
	NSMutableDictionary *gvars;			//Global Variables; saved in the global save file for things like "route cleared"-flags
	
	State *currentState;				//The current State
	
	NSStringEncoding encoding;			//Encoding for text in the novel
}

@property (nonatomic, retain) NSString *directory, *path;
@property (nonatomic, retain) NovelInfo *info;

@property (nonatomic, retain) NSMutableDictionary *saves;
@property (nonatomic, retain) NSMutableDictionary *gvars;

@property (nonatomic, retain) State *currentState;

@property (nonatomic, assign) NSStringEncoding encoding;

/**
 * Creates a Novel that reads it's data from the specified directory.
 * @param path to the novel's directory, relative to the application bundle
 */
- (id)initWithDirectory:(NSString *)path basePath:(NSString *)base;

/**
 * "Translates" a path relative to the novel directory, such as "script/main.scr", into an absolute path.
 * NOTE: Use ::contentsOfResource: for fetching resources, as this function does not support zip archives.
 * 
 * @param relativePath the relative path to translate
 * @return an absolute path to the file the relative path points to
 */
- (NSString *)relativeToAbsolutePath:(NSString *)relativePath;

/**
 * Loads the contents of a Resource.
 * This function will load zipped resources if available,
 * otherwise fall back to normal filesystem resources.
 * 
 * This function splits up a path and passes the resource and directory paths to
 * ::contentsOfResource:inDirectory:
 * 
 * @param resource the Relative Path of the Resource to be loaded, ex. 'script/main.scr'
 * @return the contents of the requested Resource, or nil if it could not be loaded
 */
- (NSData *)contentsOfResource:(NSString *)resource;

/**
 * Loads the contents of a Resource.
 * This function will load zipped resources if available,
 * otherwise fall back to normal filesystem resources.
 * 
 * @param resource the name of the resource to load
 * @param the directory (or archive) to search for it from
 * @return the contents of the requested Resource, or nil if it could not be loaded
 */
- (NSData *)contentsOfResource:(NSString *)resource inDirectory:(NSString *)directory;

/**
 * Loads the script for the given name, or throws an exception if it doesn't exist.
 */
- (void)loadScriptWithName:(NSString *)name;

/**
 * Returns the Script object for the given name
 */
- (Script *)scriptWithName:(NSString *)name;

/**
 * Scans both local and global variable sets for a variable with the given name.
 */
- (Variable *)variableForName:(NSString *)name;

@end
