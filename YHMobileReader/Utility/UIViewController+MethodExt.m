//
//  UIViewController+MethodExt.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIViewController+MethodExt.h"

@implementation UIViewController (MethodExt)

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    
    NSParameterAssert(viewController);

    // 收起弹出的键盘,该动作是应该在各自viewcontroller的disappear的时候做的，暂时放置此处
    @try {
        [self.view.window endEditing:YES];
    }
    @catch (NSException *exception) {
    }
    
   viewController.hidesBottomBarWhenPushed = YES;
    if ([self isKindOfClass:[UINavigationController class]]) {
        [self pushViewController:viewController animated:animated];
    } else {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

@end


@implementation UIViewController (tabBarItemCustom)

- (void)setTabBarItemTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    if (!self.tabBarItem) {
        return;
    }
    
    // iOS 7.0 +
    
    UITabBarItem *item;
    item = [[UITabBarItem alloc] initWithTitle:title
                                         image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                 selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem = item;
}
@end