//
//  Flag.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Variable.h"

@interface Variable(Private)
//NOTE: There's a reason why this isn't public; ONLY for internal use in -[copyWithZone]
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) id value;
@property (nonatomic, assign) VNVariableType type;

- (void)updateType;
@end

@implementation Variable
@synthesize key, value, type;

- (id)initWithKey:(NSString *)aKey value:(id)aValue
{
    self = [super init];
    if (self)
	{
		key = [aKey copy];
		value = [aValue retain];
		[self updateType];
    }
    
    return self;
}

- (NSString *)stringValue
{
	if(type == VNVariableTypeString) return value;
	else if(type == VNVariableTypeInt) return [value stringValue];
	else return nil;
}

- (NSNumber *)numberValue
{
	if(type == VNVariableTypeInt) return value;
	else return MTIntegerNumber(0);
}

- (NSInteger)integerValue
{
	if(type == VNVariableTypeInt) return [value integerValue];
	else return 0;
}

- (void)setValue:(id)aValue
{
	[value release], value = [aValue retain];
	[self updateType];
}

- (void)updateType
{
	if(value == nil) type = VNVariableTypeUnknown;
	else if([value isKindOfClass:[NSString class]]) type = VNVariableTypeString;
	else if([value isKindOfClass:[NSNumber class]]) type = VNVariableTypeInt;
	else { MTALog(@"Invalid Value Class: %@", NSStringFromClass([value class])); type = VNVariableTypeUnknown; }
}

- (id)copyWithZone:(NSZone *)zone
{
	Variable *copy = [[Variable allocWithZone:zone] init];
	copy.key = self.key;
	copy.value = self.value;
	copy.type = self.type;
	
	return copy;
}

@end
