//
//  UIViewController+MethodExt.h
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MethodExt)

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated;

@end


@interface UIViewController (tabBarItemCustom)
/**
 *    设置tabBarItem的title、image、跟selectedImage，支持只ios7
 *
 *    @param title         需要显示的文字title
 *    @param image         正常状态图像
 *    @param selectedImage 选中状态图像
 */
- (void)setTabBarItemTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@end