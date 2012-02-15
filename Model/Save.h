//
//  Save.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Novel;
@class State;
@class ScriptInterpreter;
@class CXMLElement;
@class SaveImage;

#define kSaveSlots 18

@interface Save : NSObject <NSCopying>
{
	Novel *novel;					//Parent Novel to collect data from for saving or writing to for loading (not saved in itself)
	NSInteger slot;					//Save Slot represented, -1 = Global
	BOOL exists;					//Werther the source file exists
	
	NSString *date;					//Saved Date (hh:mm yyyy/mm/dd) (don't change this!)
	State *state;					//Saved State
	
	SaveImage *image;				//The Thumbnail Image saved along with the save
}

@property (nonatomic, readonly) Novel *novel;
@property (nonatomic, assign) NSInteger slot;
@property (nonatomic, readonly) BOOL exists;

@property (nonatomic, retain) NSString *date;
@property (nonatomic, copy) State *state;
@property (nonatomic, retain) SaveImage *image;

- (id)initWithNovel:(Novel *)novel saveSlot:(NSInteger)slot;

/**
 * Collects data from the parent object for saving to disk.
 */
- (void)collectDataFromParent;

/**
 * Loads the saved date only
 */
- (void)loadDate;


#pragma mark Saving
/**
 * Saves all data and updates the image.
 * Call this function when you want to save the game.
 */
- (void)saveWithScriptInterpreter:(ScriptInterpreter *)si;

/**
 * Serializes and writes XML data to the save file.
 * Called internally by -[saveWithScriptInterpreter:].
 * 
 * Ported from VNDS's 'saveload.cpp' file, namely the function 'saveXml(VNDS* vnds, u16 slot)'
 */
- (void)saveXml;

/**
 * Updates the 'date' variable with the current date.
 * Called internally by -[saveXml].
 * 
 * Ported from VNDS's 'saveload.cpp' file, namely the function 'saveDate:(char* out);'
 */
- (void)saveDate;

/**
 * Writes all variables to the specified output NSMutableString.
 * Called internally by -[saveXml].
 * 
 * Ported from VNDS's 'saveload.cpp' file, namely the function 'saveVars(FILE* file, map<string, Variable>& varMap, u8 indent);'
 * 
 * @param str Mutable String all variables will be written to the end of
 * @param indent Indentation Level - the number of tabs inserted at the start of a line. 4 for saves, 2 for global.
 */
- (void)saveVars:(NSMutableString *)str indentation:(NSInteger)indent;

/**
 * Addition to the normal save function that saves data that improves performance of loading from
 * the iOS Interpreter.
 * 
 * @param str Mutable String to write data to
 */
- (void)saveIOSData:(NSMutableString *)str;

/**
 * Saves an iOS Cache File alongside the save containing the current text buffer
 */
- (void)saveIOSCache;

#pragma mark Loading
/**
 * Calls -[loadState] and overwrites the current state with the loaded one.
 */
- (void)loadWithScriptInterpreter:(ScriptInterpreter *)si;

/**
 * Loads data from the saved file and places it in memory, but doesn't actually overwrite the current state with the saved; that's -[loadWithScriptInterpreter:]'s job.
 * 
 * Ported from VNDS's 'saveload.cpp' file, namely the function 'loadState(VNDS *vnds, u16 slot);'.
 * FIXME: Stub
 */
- (void)loadState;

/**
 * Loads Variables from the given element.
 * 
 * @param varsElement the 'variables' element of the save file
 */
- (void)loadVars:(CXMLElement *)varsElement;

@end
