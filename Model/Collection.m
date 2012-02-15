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
	tmpUnzipDelegate = delegate;
	
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
				/*NSString *outPath = [resourcePath stringByAppendingPathComponent:
									 [filename substringToIndex:[filename length]-4]]; //4 = length of ".zip"*/
				MTLog(@"Unzipping %@ to %@", path, resourcePath);
				
				NSError *error = nil;
				[SSZipArchive unzipFileAtPath:path toDestination:resourcePath overwrite:YES password:nil error:&error delegate:self];
				if(error) MTLog(@"Novel Unzip Error: %@", error);
				
				[delegate collection:self willStartCleaningUpExtractionOfArchive:filename];
				[fileManager removeItemAtPath:path error:NULL];
				[fileManager removeItemAtPath:[resourcePath stringByAppendingPathComponent:@"__MACOSX"] error:nil];
				
				path = resourcePath;
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
				Novel *novel = [[Novel alloc] initWithDirectory:filename basePath:resourcePath];
				[novels addObject:novel];
				[novel release];
			}
		}
	}
	
	[fileManager release];
	[delegate collectionDidFinishUpdating:self];
}

- (void)zipArchiveWillUnzipFile:(NSString *)path globalInfo:(unz_global_info)header
{
	[tmpUnzipDelegate collection:self willUnzipFile:[path lastPathComponent] count:header.number_entry];
}

- (void)zipArchiveWillUnzipFileNumber:(NSInteger)number outOf:(NSInteger)total fromFile:(NSString *)path fileInfo:(unz_file_info)header
{
	[tmpUnzipDelegate collection:self willUnzipFileNumber:number outOf:total from:[path lastPathComponent]];
}

@end
