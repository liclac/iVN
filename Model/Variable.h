//
//  Flag.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Novel;

/**
 * Determines the type of a flag.
 * VNVariableTypeUnknown	= The Value is invalid - this should not happen
 * VNVariableTypeString		= The Value is an NSString, and is saved as "str"
 * VNVariableTypeInt		= The Value is an NSNumber, and is saved as "int"
 */

typedef enum VNVariableType
{
	VNVariableTypeUnknown,
	VNVariableTypeString,
	VNVariableTypeInt
} VNVariableType;

/**
 * A Flag represents a single variable in a save, as a Key, a Value and a Value Type.
 * 
 * You should never try to change any of the variables directly, as this may invalidate them.
 */

@interface Variable : NSObject <NSCopying>
{
@public //Allow direct access to iVars, used for debugging
	NSString *key;					//Key
	id value;						//Value, either an NSString or an NSNumber (copied)
	VNVariableType type;			//Value Type
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, readonly) VNVariableType type;

- (id)initWithKey:(NSString *)key value:(NSString *)value flagsFromNovel:(Novel *)novel;
- (id)initWithKey:(NSString *)key value:(id)value type:(VNVariableType)type;

- (NSString *)stringValue;
- (NSNumber *)numberValue;
- (NSInteger)integerValue;
- (id)objectValue;
- (void)setValue:(NSString *)value flagsFromNovel:(Novel *)novel;

@end
