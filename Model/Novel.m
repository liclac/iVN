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

#import "unzip.h"

@interface Novel()
- (void)loadFromDirectory;
@end

@implementation Novel
@synthesize directory, path, info;
@synthesize saves, gvars;
@synthesize currentState;
@synthesize encoding;

- (id)initWithDirectory:(NSString *)theDirectory basePath:(NSString *)base
{
	if((self = [super init]))
	{
		directory = [theDirectory retain];
		path = [[base stringByAppendingPathComponent:directory] retain];
		
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
	
	NSError *error = nil;
	NSString *infoString = [[NSString alloc] initWithContentsOfFile:[self relativeToAbsolutePath:@"info.txt"]
													   usedEncoding:&encoding error:&error];
	[infoString release];
	if(error != nil) encoding = NSUTF8StringEncoding;
	
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
}

- (NSString *)relativeToAbsolutePath:(NSString *)relativePath
{
	return [path stringByAppendingPathComponent:relativePath];
}

- (NSData *)contentsOfResource:(NSString *)resource
{
	NSArray *components = [resource pathComponents];
	NSString *dir = [components objectAtIndex:0];
	NSInteger resStartPos = [dir length]+1;
	if([resource length] <= resStartPos)
		return nil;
	NSString *res = [resource substringFromIndex:resStartPos]; //+1 = '/'
	return [self contentsOfResource:res inDirectory:dir];
}

- (NSData *)contentsOfResource:(NSString *)res inDirectory:(NSString *)dir
{
	NSData *data = nil;
	
	NSString *dirPath = [path stringByAppendingPathComponent:dir];
	
	//Attempt to load from a Zip File first
	unzFile zipFile = unzOpen([[dirPath stringByAppendingPathExtension:@"zip"] UTF8String]);
	if(zipFile != NULL)
	{
		MTLog(@"Reading from Zip...");
		if(unzLocateFile(zipFile, [res UTF8String], 0) == UNZ_OK ||
		   unzLocateFile(zipFile, [[dir stringByAppendingPathComponent:res] UTF8String], 0) == UNZ_OK)
		{
			if(unzOpenCurrentFile(zipFile) == UNZ_OK)
			{
				unz_file_info fileInfo;
				if(unzGetCurrentFileInfo(zipFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0) == UNZ_OK)
				{
					void *buffer = malloc(fileInfo.uncompressed_size);
					int readBytes = 0;
					if((readBytes = unzReadCurrentFile(zipFile, buffer, fileInfo.uncompressed_size)) >= 0)
					{
						data = [[NSData alloc] initWithBytes:buffer length:readBytes];
					}
					free(buffer);
				} else MTLog(@"ERROR: Couldn't get Current File Info");
				
				unzCloseCurrentFile(zipFile);
			} else MTLog(@"ERROR: Couldn't open Current File");
			
			unzClose(zipFile);
		} else MTLog(@"ERROR: Couldn't locate file '%@'", res);
	}
	else
	{
		MTLog(@"Reading from File...");
		data = [[NSData alloc] initWithContentsOfFile:[dirPath stringByAppendingPathComponent:res]];
	}
	
	return [data autorelease];
}

- (void)loadScriptWithName:(NSString *)name
{
	Script *script = [self scriptWithName:name];
	if(script == nil)
		[self loadScriptWithName:@"main.scr"];
	[currentState reset];
	currentState.script = script;
	[TestFlight addCustomEnvironmentInformation:name forKey:@"script"];
}

- (Script *)scriptWithName:(NSString *)name
{
	NSString *localPath = name;
	static NSString *requiredPrefix = @"script/";
	if([localPath compare:requiredPrefix options:NSCaseInsensitiveSearch range:NSMakeRange(0, [requiredPrefix length])] != NSOrderedSame)
		localPath = [@"script/" stringByAppendingPathComponent:name];
	Script *script = [[Script alloc] initWithData:[self contentsOfResource:localPath] encoding:encoding localPath:localPath novel:self];
	return [script autorelease];
}

- (Variable *)variableForName:(NSString *)name
{
	if([name hasPrefix:@"$"]) name = [name substringFromIndex:1]; //Strip $-prefix
	
	Variable *retval = [currentState.vars objectForKey:name];
	if(retval == nil) retval = [gvars objectForKey:name];
	
	return retval;
}

@end
