//
//  UIScreen+NineClub.h
//  common
//
//  Created by logiph on 4/2/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//


///-------------------------------
/// @name 设备屏幕 大小
///-------------------------------

/**
 设备屏幕的宽度
 */
extern CGFloat const kUIScreen_Width;

/**
 设备屏幕高度，包括statusbar
 */
extern CGFloat const kUIScreen_Height;


///-------------------------------
/// @name 应用程序 界面 各组件 大小
///-------------------------------

/**
 *  controller view的Top, ios6及以下为20， ios7为0
 */
extern CGFloat const kUIScreen_AppTop;

/**
 设备屏幕高度 除去statusbar的高度 即 `kUIScreen_Height` - 20 
 */
extern CGFloat const kUIScreen_AppHeight;

/**
 界面顶部栏的高度
 */
extern CGFloat const kUIScreen_TopBarHeight;

/**
 设备屏幕高度 除去statusbar和kUIScreen_TopBarHeight bar的高度
 即 `kUIScreen_Height` - 20 - 44
 */
extern CGFloat const kUIScreen_AppContentHeight;

/**
 界面 底部栏的高度
 */
extern CGFloat const kUIScreen_BottomBarHeight;


///-------------------------------
/// @name 应用程序 内容区域 参数定义
///-------------------------------

/**
 界面内容与 左右以及底部的Padding
 */
extern CGFloat const kUIScreen_ContentViewPadding;

/**
 界面内容的宽度
 */
extern CGFloat const kUIScreen_ContentViewWidth;

/**
 界面内容的高度
 */
extern CGFloat const kUIScreen_ContentViewHeight;


///-------------------------------
/// @name 应用程序 屏幕尺寸定义
///-------------------------------

/**
 是否是iphone4 的屏幕 分辨率
 */
extern BOOL const kUIScreen_IPHONE_4;

/**
 是否是iphone5 的屏幕 分辨率
 */
extern BOOL const kUIScreen_IPHONE_5;


/**
 iphone5 内容中的数据距离内容界面的宽度
 */
extern CGFloat const kUIScreen_ContentOffsetFrameWidth;
/**
 iphone5 内容中的数据距离内容界面的高度
 */
extern CGFloat const kUIScreen_ContentOffsetFrameHeight;

/**
 iphone5 内容中的数据距离内容界面的高度
 */
extern CGFloat const kUIScreen_ContentFrameRadius;

/**
 iphone5 内容中的数据距离内容界面的高度
 */
extern CGFloat const kUIScreen_IPHONE_5_PDDING;

/**
 针对项目程序页面，对于各个页面做一些扩展。
 */
@interface UIScreen (Common)


+ (void)initialUIScreenParam;

@end
