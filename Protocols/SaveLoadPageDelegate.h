//
//  SaveLoadPageDelegate.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-24.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SaveLoadPageViewController;

@protocol SaveLoadPageDelegate <NSObject>

- (void)saveLoadPage:(SaveLoadPageViewController *)page didHighlightSlot:(NSInteger)slot;

@end
