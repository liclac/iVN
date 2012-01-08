//
//  SaveImage.h
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-24.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Save;

#define kSaveImageWidth 64
#define kSaveImageHeight 48

#pragma pack(push,1)
typedef struct
{
	unsigned char a:1;
	unsigned char r:5;
	unsigned char g:5;
	unsigned char b:5;
} argb16_t;
#pragma pack(pop)

@interface SaveImage : NSObject
{
	UIImage *img;
	Save *save;
	NSString *path;
}

@property (nonatomic, readonly) UIImage *img;
@property (nonatomic, assign) Save *save;

- (id)initWithSave:(Save *)save;
- (void)loadFromFile;
- (void)createFromView:(UIView *)view;
- (void)writeToFile;

@end
