//
//  ChoiceDelegate.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-23.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChoiceViewController;

@protocol ChoiceDelegate <NSObject>

- (void)choiceClosed:(ChoiceViewController *)choice;

@end
