//
//  Flag.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Variable.h"
#import "Novel.h"

@interface Variable()
//NOTE: There's a reason why this isn't public; ONLY for internal use in Copy operations
@property (nonatomic, retain) id value;
@property (nonatomic, assign) VNVariableType type;
@end

@implementation Variable
@synthesize key, value, type;

- (id)initWithKey:(NSString *)aKey value:(NSString *)aValue flagsFromNovel:(Novel *)novel
{
    if((self = [super init]))
	{
		key = [aKey copy];
		[self setValue:aValue flagsFromNovel:novel];
    }
    
    return self;
}

- (id)initWithKey:(NSString *)key_ value:(id)value_ type:(VNVariableType)type_
{
	if((self = [super init]))
	{
		key = [key_ copy];
		value = [value_ retain];
		type = type_;
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

- (id)objectValue
{
	return value;
}

- (void)setValue:(NSString *)value_ flagsFromNovel:(Novel *)novel
{
	const char *valuechars = [value_ UTF8String];
	if([value_ isEqualToString:@"~"])
	{
		value = nil; //I assume ~ means unset. Damn unclear specifications...
	}
	else if(valuechars[0] == '"')
	{
		char *valuecopy = strdup(valuechars+1);
		if(valuecopy[strlen(valuecopy)-1] == '"') valuecopy[strlen(valuecopy)-1] = '\0';
		value = [[NSString alloc] initWithUTF8String:valuecopy];
		free(valuecopy);
		type = VNVariableTypeString;
	}
	else if(isdigit(valuechars[0]))
	{
		int intval = atoi(valuechars);
		value = [[NSNumber alloc] initWithInt:intval];
		type = VNVariableTypeInt;
	}
	else
	{
		Variable *copyVar = [novel variableForName:value_];
		if(copyVar != nil)
		{
			value = [copyVar.value retain];
			type = [copyVar type];
		}
		else
		{
			value = [value_ copy];
			type = VNVariableTypeString;
		}
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	Variable *copy = [[Variable allocWithZone:zone] init];
	copy.key = self.key;
	copy.value = self.value;
	copy.type = self.type;
	
	return copy;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Variable (%@): %@ = %@",
			(type == VNVariableTypeUnknown ? @"???" : (type == VNVariableTypeInt ? @"int" : @"str")), key, value];
}

@end
