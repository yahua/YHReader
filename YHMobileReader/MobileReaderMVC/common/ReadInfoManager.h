//
//  ReadInfoManager.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWidth  (kUIScreen_Width - 30)
#define kHeight  (kUIScreen_Height - 86)

//单例
@interface ReadInfoManager : NSObject

/**
 阅读界面的字体大小
 */
@property (nonatomic, assign) NSInteger fontSize;

/**
 每一行显示的字体个数
 */
@property (nonatomic, assign) NSInteger eachRowNums;

/**
 总共有多少行
 */
@property (nonatomic, assign) NSInteger rowNums;

/**
 每个页面最多显示字体个数
 */
@property (nonatomic, assign) NSInteger maxNumCharacter;

/**
 显示的textView距离左边的间距
 */
@property (nonatomic, assign) CGFloat leftPadding;

/**
 距离顶部的间距
 */
@property (nonatomic, assign) CGFloat topPadding;

/**
 背景id
 */
@property (nonatomic, assign) NSInteger backgroundID;

/**
 上次背景id
 */
@property (nonatomic, assign) NSInteger lastBackgroundID;

/**
 背景色
 */
@property (nonatomic, copy) UIColor *backgroundColor;

/**
 字体颜色
 */
@property (nonatomic, copy) UIColor *fontColor;

/**
 屏幕亮度
 */
@property (nonatomic, assign) CGFloat light;

/**
 翻页方式
 */
@property (nonatomic, assign) NSInteger pageMethod;

+ (ReadInfoManager *)shareReadInfoManager;

- (void)updateReadInfo;

- (void)setScreenLight:(CGFloat)light;

- (void)lessFont;

- (void)addFont;

- (void)changePageMethod:(NSInteger)pageMethod;

- (void)changeBackgroundColor:(NSInteger)colorID;

- (void)restoreLastColor;

@end
