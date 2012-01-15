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

- (void)collection:(Collection *)collection willUnzipFile:(NSString *)filename count:(NSInteger)count;
- (void)collection:(Collection *)collection willReadSoundFromNovel:(NSString *)filename;
- (void)collection:(Collection *)collection willUnzipFileNumber:(NSInteger)number outOf:(NSInteger)total from:(NSString *)from;
- (void)collectionDidFinishUpdating:(Collection *)collection;

@end
