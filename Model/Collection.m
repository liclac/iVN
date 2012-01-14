//
//  Collection.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "Collection.h"
#import "SynthesizeSingleton.h"
#import "Novel.h"
#import "SSZipArchive.h"

@implementation Collection
@synthesize novels;

SYNTHESIZE_SINGLETON_FOR_CLASS(Collection)

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self)
	{
		
    }
    
    return self;
}

- (void)loadCollectionWithDelegate:(id<CollectionDelegate>)delegate
{
	[novels release]; //Security Device; it should already be nil
	novels = [[NSMutableArray alloc] init];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	NSArray *paths = [[NSArray alloc] initWithObjects:[[NSBundle mainBundle] resourcePath], [[NSBundle mainBundle] documentsPath], nil];
	for(NSString *resourcePath in paths)
	{
		NSArray *contents = [fileManager contentsOfDirectoryAtPath:resourcePath error:nil];
		for(NSString *filename in contents)
		{
			NSString *path = [resourcePath stringByAppendingPathComponent:filename];
			BOOL isDir = NO;
			
			[fileManager fileExistsAtPath:path isDirectory:&isDir];
			
			if(!isDir && [[path pathExtension] isEqualToString:@"zip"])
			{
				NSString *outPath = [resourcePath stringByAppendingPathComponent:
									 [filename substringToIndex:[filename length]-4]]; //4 = length of ".zip"
				MTLog(@"Unzipping %@ to %@", path, outPath);
				[delegate collection:self willUnzipFile:filename];
				
				NSError *error = nil;
				[SSZipArchive unzipFileAtPath:path toDestination:outPath overwrite:YES password:nil error:&error];
				if(error) MTLog(@"Novel Unzip Error: %@", error);
				[fileManager removeItemAtPath:path error:NULL];
				[fileManager removeItemAtPath:[outPath stringByAppendingPathComponent:@"__MACOSX"] error:nil];
				
				if(!error && [fileManager fileExistsAtPath:[outPath stringByAppendingPathComponent:@"sound.zip"]])
				{
					NSString *soundPath = [outPath stringByAppendingPathComponent:@"sound.zip"];
					NSString *soundOut = [outPath stringByAppendingPathComponent:@"sound"];
					
					[delegate collection:self willReadSoundFromNovel:[outPath lastPathComponent]];
					[SSZipArchive unzipFileAtPath:soundPath
									toDestination:soundOut
										overwrite:YES password:nil error:&error];
					[fileManager removeItemAtPath:[outPath stringByAppendingPathComponent:@"sound.zip"] error:NULL];
					if(error) MTLog(@"Sound Unzip Error: %@", error);
					
					NSString *sound2Path = [soundOut stringByAppendingPathComponent:@"sound"];
					BOOL sound2IsDir = NO;
					BOOL sound2Exists = [fileManager fileExistsAtPath:sound2Path isDirectory:&sound2IsDir];
					if(sound2Exists && sound2IsDir)
					{
						NSArray *s2contents = [fileManager contentsOfDirectoryAtPath:sound2Path error:NULL];
						for(NSString *name in s2contents)
						{
							[fileManager moveItemAtPath:[sound2Path stringByAppendingPathComponent:name]
												 toPath:[soundOut stringByAppendingPathComponent:name]
												  error:NULL];
						}
						
						[fileManager removeItemAtPath:sound2Path error:NULL];
					}
				}
				
				path = outPath;
				filename = [path lastPathComponent];
				isDir = YES;
			}
			
			MTLog(@"%d: %@", isDir, path);
			
			if(isDir)
			{
				//Skip folders that are not novels
				if(![fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"info.txt"]])
				{
					MTLog(@"Couldn't find info.txt in %@", path);
					continue;
				}
				
				MTLog(@"%@", filename);
				Novel *novel = [[Novel alloc] initWithDirectory:filename];
				[novels addObject:novel];
				[novel release];
			}
		}
	}
	
	[fileManager release];
	[delegate collectionDidFinishUpdating:self];
}

@end
