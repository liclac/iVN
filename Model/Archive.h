//
//  Archive.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-12-17.
//  Copyright (c) 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Archive : NSObject
{
	NSString *path;
}

- (id)initWithFileAtPath:(NSString *)path;
- (NSData *)contentsOfFile:(NSString *)filename;

@end
