//
//  UIImage_Extended.h
//  Weather
//
//  Created by logiph on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIScreen+Common.h"


@implementation UIImage (Extended)
    
+ (UIImage *)imageWithContentsOfName:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (UIImage *)imageWithRelativeFile:(NSString *)imageFile {
    
    NSString *imagePath = [NSHomeDirectory()
                            stringByAppendingPathComponent: imageFile];
    
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
    
}
+ (UIImage *)imageWithContentsOfName:(NSString *)imageName withSize:(CGSize)size
{
    UIImage *rawImage = [self imageWithContentsOfName:imageName];
    return [rawImage reSizeImageToSize:size];
}

- (UIImage *)reSizeImageToSize:(CGSize)reSize {
//    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
//    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return reSizeImage;
//    
    // Create a graphics context with the target size
     // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
     // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(reSize, NO, 0);
    else
        UIGraphicsBeginImageContext(reSize);

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, reSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, reSize.width, reSize.height), self.CGImage);

    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return imageOut;
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(image2.size, NO, 0);
    else
        UIGraphicsBeginImageContext(image2.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, image2.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
    //    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, image2.size.width, image2.size.height), image2.CGImage);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, image1.size.width, image1.size.height), image1.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withSize:(CGSize)reSize{
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(reSize, NO, 0);
    else
        UIGraphicsBeginImageContext(reSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, reSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
//    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, reSize.width, reSize.height), image2.CGImage);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, reSize.width, reSize.height), image1.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

//图片裁剪
+(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
//    CGImageRef imageRef = superImage.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
//    UIGraphicsBeginImageContext(subImageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, subImageRect, subImageRef);
//    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext(); //返回裁剪的部分图像
//    return returnImage;
    
    if (superImage) {
        CGImageRef imageRef = superImage.CGImage;
        
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
        
        
        UIGraphicsBeginImageContext(subImageSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextDrawImage(context, subImageRect, subImageRef);
        
        UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
        
        CGImageRelease(subImageRef);
        UIGraphicsEndImageContext();
        
        
        return smallImage;
    }else{
        return nil;
    }

}

- (UIImage*)cutImageToFullScreenSize:(UIImage*)theImage{
    
    UIImage * bigImage = theImage;
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    float actualRatio = actualWidth / actualHeight;
    CGSize reduceSize;
    
    float iphone5Ratio = 640.0/1136.0;
    if (iphone5Ratio == actualRatio) {
        reduceSize = CGSizeMake(320, 568);
    }else{
        reduceSize = CGSizeMake(320,480);
    }
    
    CGRect rect = CGRectMake(0, 0, reduceSize.width, reduceSize.height);
    UIGraphicsBeginImageContext(reduceSize);
    [bigImage drawInRect:rect];  // scales image to rect
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cutRect = CGRectMake((reduceSize.width - kUIScreen_Width) *.5, (reduceSize.height -kUIScreen_AppHeight)*.5 , kUIScreen_Width, kUIScreen_AppHeight);
    UIImage *cutImage = [UIImage getImageFromImage:theImage subImageSize:cutRect.size subImageRect:cutRect];
    return cutImage;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize  {
    
     UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
     [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
     UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    
     return scaledImage;
 }

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

- (UIImage *)resizeImageWithCapInsets:(UIEdgeInsets)capInsets {
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *image = nil;
    if (systemVersion >= 5.0) {
        image = [self resizableImageWithCapInsets:capInsets];
        return image;
    }
    image = [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    return image;
}
@end
