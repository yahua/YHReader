//
//  UIScreen+NineClub.m
//  common
//
//  Created by logiph on 4/2/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

#import "UIScreen+Common.h"


CGFloat const kUIScreen_Width;

CGFloat const kUIScreen_Height;

CGFloat const kUIScreen_AppTop;

CGFloat const kUIScreen_AppHeight;

CGFloat const kUIScreen_TopBarHeight;

CGFloat const kUIScreen_AppContentHeight;

CGFloat const kUIScreen_BottomBarHeight;

CGFloat const kUIScreen_ContentViewHeight;

BOOL const kUIScreen_IPHONE_4;

BOOL const kUIScreen_IPHONE_5;

CGFloat const kUIScreen_IPHONE_5_PDDING;






@implementation UIScreen (Common)

+ (void)initialUIScreenParam {
     

    *((CGFloat *)&kUIScreen_Width) = 320;

    *((CGFloat *)&kUIScreen_Height) = [UIScreen mainScreen].bounds.size.height;
    
    *((CGFloat *)&kUIScreen_AppTop) = 20;
    
    *((CGFloat *)&kUIScreen_AppHeight) = kUIScreen_Height - 20;
    
    *((CGFloat *)&kUIScreen_TopBarHeight) = 44;

    *((CGFloat *)&kUIScreen_AppContentHeight) = kUIScreen_Height - 20 - kUIScreen_TopBarHeight;
    
    *((CGFloat *)&kUIScreen_BottomBarHeight) = 50;
    
    // ContentView
    *((CGFloat *)&kUIScreen_ContentViewHeight) = kUIScreen_AppHeight - kUIScreen_TopBarHeight - kUIScreen_BottomBarHeight;


    // 屏幕尺寸定义
    BOOL iphone5 = ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON );
    *((BOOL *)&kUIScreen_IPHONE_4) = !iphone5;
    *((BOOL *)&kUIScreen_IPHONE_5) = iphone5;
    
    *((CGFloat *)&kUIScreen_IPHONE_5_PDDING) = 88.0;
    
}

@end
