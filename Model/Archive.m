//
//  Archive.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-12-17.
//  Copyright (c) 2011 MacaroniCode Software. All rights reserved.
//

#import "Archive.h"
#import "unzip.h"

@implementation Archive

- (id)initWithFileAtPath:(NSString *)path_
{
	if((self = [super init]))
	{
		path = [path_ retain];
	}
	
	return self;
}

- (NSData *)contentsOfFile:(NSString *)filename
{
	unzFile file = unzOpen([path UTF8String]);
	if(file == NULL)
	{
		NSLog(@"Couldn't unzOpen file at path %@", path);
		return nil;
	}
	
	if(unzLocateFile(file, [filename UTF8String], 0) != UNZ_OK)
	{
		NSLog(@"Couldn't locate file %@ in %@!", filename, path);
		return nil;
	}
	
	if(unzOpenCurrentFile(file) != UNZ_OK)
	{
		NSLog(@"Couldn't open archived file for reading!");
		return nil;
	}
	
	NSMutableData *data = [[NSMutableData alloc] init];
	char buffer[1024];
	int readLength = 0;
	while((readLength = unzReadCurrentFile(file, &buffer, sizeof(char)*1024) > 0))
	{
		[data appendBytes:buffer length:readLength];
	}
	
	return [data autorelease];
}

@end
