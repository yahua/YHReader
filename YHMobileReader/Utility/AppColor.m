//
//  AppColor.m
//  Common
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

#import "AppColor.h"
#import "UIColor+Hex.h"
#import <objc/runtime.h>


#define kSingletonColor(instance, color) \
    static UIColor *instance = nil;      \
    static dispatch_once_t onceToken;    \
    dispatch_once(&onceToken, ^{         \
        instance = color;                \
        [instance retain];               \
    });

#define kDispatchAllocSingleton(instance, implement) \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[objc_getClass(implement) alloc] init];\
});

#define HexColor(value) (value/255.0)

@implementation AppColor

#pragma mark -
#pragma mark AppColor

- (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:HexColor(224)
                           green:HexColor(223)
                            blue:HexColor(223)
                           alpha:1];
}

- (UIColor *)cellLineColor {
    
    return [UIColor colorWithRed:HexColor(0xb7)
                           green:HexColor(0xb6)
                            blue:HexColor(0xb6)
                           alpha:1];
}

- (UIColor *)cellSeparatorColor {
    
    return [UIColor colorWithRed:HexColor(0xb7)
                           green:HexColor(0xb6)
                            blue:HexColor(0xb6)
                           alpha:1];
}

///-------------------------------
/// @name 姓名测试、匹配、梅花占卜颜色定义
///-------------------------------

/**
 定死的文本字体颜色
 */
- (UIColor *)_0x694f40 {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0x694f40]);
    return color;
}

/**
 变化的文本字体颜色
 */
- (UIColor *)_0x473125 {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0x473125]);
    return color;
}

/**
 变化的文本字体颜色 0.6 alpha
 */
- (UIColor *)_0x473125_60 {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0x473125 alpha:0.6]);
    return color;
}

/**
 蓝色
 */
- (UIColor *)_0x0a7ed1 {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0x0a7ed1]);
    return color;
}

/**
 名字的黄色
 */
- (UIColor *)_0xcc680a {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0xcc680a]);
    return color;
}

/**
 数字的黄色
 */
- (UIColor *)_0xdd3b0a {
    
    kSingletonColor(color,
                    [UIColor colorWithHex:0xdd3b0a]);
    return color;
}

- (UIColor *)_0xffffff_60 {
    
    kSingletonColor(color, [UIColor colorWithHex:0xffffff alpha:0.6]);
    return color;
}



+ (id<AppColor>)shareAppColor {
    
    kDispatchAllocSingleton(instance, "AppColor");
    return instance;
}

@end
