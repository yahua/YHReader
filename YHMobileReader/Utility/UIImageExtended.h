//
//  UIImage_Extended.h
//  Weather
//
//  Created by logiph on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



@interface UIImage (Extended)

/**
 从文件中读取图片
 @param imageName    图片名称，默认从mainBundle中查找
 */
+ (UIImage *)imageWithContentsOfName:(NSString *)imageName;

/**
 从应用安装路径中读取图片
 @param imageFile    图片相对路径
 */
+ (UIImage *)imageWithRelativeFile:(NSString *)imageFile;

/**
 从文件中读取图片，并压缩尺寸大小
 @param imageName    图片名称，默认从mainBundle中查找
 @param size         压缩的图片大小 
 */
+ (UIImage *)imageWithContentsOfName:(NSString *)imageName withSize:(CGSize)size;

/**
 将图片进行尺寸压缩
 @param size         压缩的图片大小
 */
- (UIImage *)reSizeImageToSize:(CGSize)reSize;

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

/**
 裁剪到原图片到相应的尺寸
 @param superImage   要裁剪的原图
 @param subImageSize 需要裁剪的大小
 @param subImageRect 需要裁剪frame，包含起始在原图的起始位置
 */
+ (UIImage *)getImageFromImage:(UIImage*)superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect;

/**
  裁剪到全屏尺寸的图片，将一个超过全屏尺寸的图片裁剪到屏幕尺寸的大小，并
  裁剪到中间位置。
  一些图片是1136*640大小的尺寸，而iphone4为960*320尺寸，因此需要裁剪
  到图片居中的位置
 
  @warning: 该函数只适用于1136*640尺寸，或者960*640尺寸的图片裁剪，其他尺寸
  的裁剪，请使用getImageFromImage:subImageSize:subImageRect 裁剪接口
 */
- (UIImage*)cutImageToFullScreenSize:(UIImage*)theImage;

/**
 将两张图片进行叠加
 @param image1         叠加的原图
 @param image2         叠加在原图上的图片
 @param image1         叠加后压缩的尺寸
 */
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withSize:(CGSize)reSize;

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets;
@end