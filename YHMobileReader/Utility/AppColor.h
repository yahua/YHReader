//
//  AppColor.h
//  Common
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

/**
 定义整个程序共通的颜色
 
 */
@protocol AppColor

- (UIColor *)backgroundColor;
- (UIColor *)cellLineColor;
- (UIColor *)cellSeparatorColor;

/**
 定死的文本字体颜色
 */
- (UIColor *)_0x694f40;

/**
 变化的文本字体颜色
 */
- (UIColor *)_0x473125;

/**
 变化的文本字体颜色 0.6 alpha
 */
- (UIColor *)_0x473125_60;

/**
 蓝色
 */
- (UIColor *)_0x0a7ed1;

/**
 名字的黄色
 */
- (UIColor *)_0xcc680a;

/**
 数字的黄色
 */
- (UIColor *)_0xdd3b0a;

/**
 90%的白色
 */
- (UIColor *)_0xffffff_60;

@end



@interface AppColor : NSObject <
AppColor
>

+ (id<AppColor>)shareAppColor;

 @end
