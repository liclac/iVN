//
//  CollectionDelegate.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-25.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Collection;

@protocol CollectionDelegate <NSObject>

- (void)collection:(Collection *)collection willUnzipFile:(NSString *)filename;
- (void)collection:(Collection *)collection willReadSoundFromNovel:(NSString *)filename;
- (void)collectionDidFinishUpdating:(Collection *)collection;

@end
