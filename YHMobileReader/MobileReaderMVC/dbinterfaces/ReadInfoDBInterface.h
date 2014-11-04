//
//  ReadInfoDBInterface.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ReadInfo.h"

@protocol ReadInfoDBInterface

/**
 获取阅读信息
 */
- (ReadInfo *)getReadInfo;

/**
 设置背景色
 */
- (void)setBackgroundColor:(NSInteger)colorID;

/**
 设置字体大小
 */
- (void)setFontSize:(NSInteger)fontSize;

/**
 设置屏幕亮度
 */
- (void)setScreenLight:(NSInteger)screenLight;

/**
 设置翻页方式
 */
- (void)setPageMethod:(NSInteger)pageMethod;

@end
