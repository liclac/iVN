//
//  Novel.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Novel.h"
#import "NovelInfo.h"
#import "Script.h"
#import "Settings.h"
#import "State.h"
#import "Save.h"
#import "Variable.h"
#import "Command.h"

@interface Novel(Private)
- (void)loadFromDirectory;
@end

@implementation Novel
@synthesize directory, path, info;
@synthesize saves, gvars;
@synthesize scripts, currentState;

- (id)initWithDirectory:(NSString *)theDirectory
{
	if((self = [super init]))
	{
		directory = [theDirectory retain];
#if TARGET_IPHONE_SIMULATOR
		NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
#else
		NSString *resourcePath = [[NSBundle mainBundle] documentsPath];
#endif
		path = [[resourcePath stringByAppendingPathComponent:directory] retain];
		
		[self loadFromDirectory];
	}
	
	return self;
}

- (void)loadFromDirectory
{
	/*
	 * --->
	 * ---> WARNING:
	 * --->
	 * 
	 * This is only called from within the initializer, which means that assigning properties (eg. self.whatever = value) isn't safe.
	 * Instead use "whatever = [value retain]" or similar
	 */
	
	
	
	
	
	
	
	
	
	NSFileManager *fm = [[NSFileManager alloc] init];
	NSString *scriptPath = [self relativeToAbsolutePath:@"script"];
	NSArray *scriptFiles = [fm contentsOfDirectoryAtPath:scriptPath error:NULL];
	
	scripts = [[NSMutableDictionary alloc] initWithCapacity:[scriptFiles count]];
	for(NSString *file in scriptFiles)
	{
		Script *script = [[Script alloc] initWithContentsOfFile:[@"script/" stringByAppendingPathComponent:file]
														absPath:[scriptPath stringByAppendingPathComponent:file]];
		[scripts setObject:script forKey:[@"script/" stringByAppendingPathComponent:file]];
		[script release];
	}
	MTLog(@"\n%@", scripts);
	[fm release];
	
	saves = [[NSMutableDictionary alloc] init];
	for(NSInteger i = -1; i < kSaveSlots; i++)
	{
		Save *save = [[Save alloc] initWithNovel:self saveSlot:i];
		if(i == -1)
		{
			[save loadWithScriptInterpreter:nil];
			gvars = save.state.vars;
		}
		[saves setObject:save forKey:[NSNumber numberWithInteger:i]];
		[save release];
	}
	
	info = [[NovelInfo alloc] initWithNovel:self];
	currentState = [[State alloc] init];
	[self loadScriptWithName:@"main.scr"];
}

- (NSString *)relativeToAbsolutePath:(NSString *)relativePath
{
	return [path stringByAppendingPathComponent:relativePath];
}

- (void)loadScriptWithName:(NSString *)name
{
	Script *script = [scripts objectForKey:[@"script/" stringByAppendingPathComponent:name]];
	[currentState reset];
	currentState.script = script;
}

- (Variable *)variableForName:(NSString *)name
{
	if([name hasPrefix:@"$"]) name = [name substringFromIndex:1]; //Strip $-prefix
	
	Variable *retval = [currentState.vars objectForKey:name];
	if(retval == nil) retval = [gvars objectForKey:name];
	
	return retval;
}

@end
