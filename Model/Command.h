//
//  Command.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Script;

/**
 * Command Type.
 * More or less copy-pasted from the original VNDS's 'script_engine.h' file, only prefixed and with an UNKNOWN command type added in.
 */
typedef enum VNCommandType
{
	VNCommandTypeUNKNOWN, //Unrecognized commands, newlines and malformed commands
	VNCommandTypeBGLOAD,
    VNCommandTypeSETIMG,
    VNCommandTypeSOUND,
    VNCommandTypeMUSIC,
    VNCommandTypeTEXT,
    VNCommandTypeCHOICE,
    VNCommandTypeSETVAR,
    VNCommandTypeGSETVAR,
    VNCommandTypeIF,
    VNCommandTypeFI,
    VNCommandTypeJUMP,
    VNCommandTypeDELAY,
    VNCommandTypeRANDOM,
    VNCommandTypeSKIP,
    VNCommandTypeENDSCRIPT,
    VNCommandTypeLABEL,
    VNCommandTypeGOTO,
    VNCommandTypeCLEARTEXT,
	VNCommandTypeEND_OF_FILE //Unused
} VNCommandType;

/**
 * A Command object represents a single command in a script file.
 * 
 * Note that you should NEVER try to create a Command object outside of a Script object's initializer,
 * as the Script object performs several checks and assignments the Command can't do by itself due to lacking a Script-context.
 */
@interface Command : NSObject
{
	Script *script;			//Parent Scripts
	VNCommandType type;		//The Command Type
	NSString  *string;		//The String the command was created from
	NSArray *parameters;	//Parameters (the string split by whitespace minus the command name)
	NSString *text;			//Text used by the text command to avoid having to reassemble the above array back into a string repeatedly
	NSInteger endPosition;	//Used by the "if"-command to determine where the corresponding FI is (assigned by the parent Script object)
}

@property (nonatomic, assign) Script *script;
@property (nonatomic, assign) VNCommandType type;
@property (nonatomic, readonly) NSString *string;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) NSInteger endPosition;

- (id)initWithString:(NSString *)str script:(Script *)script;
- (id)parameterAtIndex:(NSInteger)index defaultValue:(id)defval;
- (id)parameterAtIndex:(NSInteger)index defaultValue:(id)defval maybeVariable:(BOOL)mv;
- (NSInteger)parameterCount;

@end
