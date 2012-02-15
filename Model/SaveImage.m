//
//  SaveImage.m
//  iVN
//
//  Created by Johannes Ekberg on 2011-07-24.
//  Copyright 2011 MacaroniCode Software. All rights reserved.
//

#import "SaveImage.h"
#import "Save.h"
#import "Novel.h"

@implementation SaveImage
@synthesize img, save;

- (id)initWithSave:(Save *)iSave
{
    if ((self = [super init]))
	{
		save = iSave;
		path = [[save.novel relativeToAbsolutePath:[NSString stringWithFormat:@"save/save%02d.img", save.slot]] retain];
    }
    
    return self;
}

- (void)loadFromFile
{
	NSData *fdata = [[NSData alloc] initWithContentsOfFile:path];
	
	const char *rdata = [fdata bytes];
	argb16_t data[kSaveImageHeight*kSaveImageWidth];
	memcpy(data, rdata, [fdata length]);
	for(int i = 0; i < kSaveImageHeight*kSaveImageWidth; i++)
	{
		argb16_t argb = data[i];
		data[i].r = argb.b;
		data[i].g = argb.g;
		data[i].b = argb.r;
	}
	NSData *swappedData = [[NSData alloc] initWithBytes:data length:[fdata length]];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)swappedData);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGImageRef cImage = CGImageCreate
	(
	 kSaveImageWidth, kSaveImageHeight,						//The Image's Width and Height
	 5, 16, kSaveImageWidth*2,								//Bits per Color Component, per pixel, and the number of bytes per row
	 colorSpace,											//Colorspace
	 kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder16Little,	//Options
	 provider,												//Data Source (pipeline to the image data)
	 NULL,													//Decode Array for fine-tuning colors (not used)
	 YES,													//Werther it should be interpolated when scaled (it will look awful otherwise)
	 kCGRenderingIntentDefault								//Color for display on a screen, not paper
	 );
	
	img = [[UIImage alloc] initWithCGImage:cImage scale:1 orientation:UIImageOrientationUp];
	
	CGImageRelease(cImage);
	CGColorSpaceRelease(colorSpace);
	
	CGDataProviderRelease(provider);
	[fdata release];
	[swappedData release];
}

- (void)createFromView:(UIView *)view
{
	UIGraphicsBeginImageContext(view.frame.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)writeToFile
{
	CGImageRef image = [img CGImage];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	char *cdata = malloc(kSaveImageWidth*kSaveImageHeight*sizeof(argb16_t));
	CGContextRef context = CGBitmapContextCreate(cdata, kSaveImageWidth, kSaveImageHeight, 5, kSaveImageWidth*sizeof(argb16_t), colorSpace, kCGBitmapByteOrder16Little|kCGImageAlphaNoneSkipFirst);
	CGColorSpaceRelease(colorSpace);
	
	CGContextDrawImage(context, CGRectMake(0, 0, kSaveImageWidth, kSaveImageHeight), image);
	
	argb16_t data[kSaveImageHeight*kSaveImageWidth];
	memcpy(data, cdata, kSaveImageHeight*kSaveImageWidth*sizeof(argb16_t));
	for(int i = 0; i < kSaveImageHeight*kSaveImageWidth; i++)
	{
		argb16_t argb = data[i];
		data[i].b = argb.r;
		data[i].g = argb.g;
		data[i].r = argb.b;
	}
	
	NSData *fdata = [[NSData alloc] initWithBytes:data length:sizeof(data)];
	[fdata writeToFile:path atomically:YES];
	[fdata release];
	
	CGContextRelease(context);
	free(cdata);
}

@end
