//
//  Collection.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-21.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionDelegate.h"

/**
 * Keeps a global list of all known novels.
 */

@interface Collection : NSObject
{
	NSMutableArray *novels;
}

@property (nonatomic, readonly) NSMutableArray *novels;

+ (Collection *)sharedCollection;
- (void)loadCollectionWithDelegate:(id<CollectionDelegate>)delegate;

@end
