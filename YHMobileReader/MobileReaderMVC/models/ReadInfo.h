//
//  ReadInfo.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 阅读信息模型
 */
@interface ReadInfo : NSObject

/**
 阅读者ID
 */
@property (nonatomic, assign) NSInteger readerID;

/**
 背景色
 */
@property (nonatomic, assign) NSInteger backgroundColorID;

/**
 字体大小
 */
@property (nonatomic, assign) NSInteger fontSize;

/**
 屏幕亮度
 */
@property (nonatomic, assign) NSInteger screenLight;

/**
 翻页方式
 */
@property (nonatomic, assign) NSInteger pageMethod;

@end
