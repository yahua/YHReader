//
//  UIVCYahuaController.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCYahuaController.h"
#import "UIVCBookRack.h"
#import "UIVCBookCityController.h"
#import "UIVCMineViewController.h"
#import "UIImageExtended.h"

@interface UIVCYahuaController ()

@end

@implementation UIVCYahuaController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self presentBottomTabBarController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)presentBottomTabBarController {
    
    UIVCBookRack *bookRack = [[UIVCBookRack alloc] init];
    UIImage *finishedSelectImage = [UIImage imageWithContentsOfName:@"bookrack_icon_touch@2x.png" withSize:CGSizeMake(27, 27)];
    UIImage *finishedUnSelectImage = [UIImage imageWithContentsOfName:@"bookrack_icon_normal@2x.png" withSize:CGSizeMake(27, 27)];
    [bookRack setTabBarItemTitle:@"书架" image:finishedUnSelectImage selectedImage:finishedSelectImage];
    
    UIVCBookCityController *bookCity = [[UIVCBookCityController alloc] init];
    finishedSelectImage = [UIImage imageWithContentsOfName:@"bookcity_icon_touch@2x.png" withSize:CGSizeMake(27, 27)];
    finishedUnSelectImage = [UIImage imageWithContentsOfName:@"bookcity_icon_normal@2x.png" withSize:CGSizeMake(27, 27)];
    [bookCity setTabBarItemTitle:@"书城" image:finishedUnSelectImage selectedImage:finishedSelectImage];
    
    UIVCMineViewController *mine = [[UIVCMineViewController alloc] init];
    finishedSelectImage = [UIImage imageWithContentsOfName:@"mine_icon_touch@2x.png" withSize:CGSizeMake(27, 27)];
    finishedUnSelectImage = [UIImage imageWithContentsOfName:@"mine_icon_normal@2x.png" withSize:CGSizeMake(27, 27)];
    [mine setTabBarItemTitle:@"我的" image:finishedUnSelectImage selectedImage:finishedSelectImage];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:bookRack];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:bookCity];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:mine];
    nav3.navigationBarHidden = YES;
    
    self.viewControllers = @[nav1, nav2, nav3];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *tabBarItem, NSUInteger idx, BOOL *stop) {
        
        UIColor *normalTextColor = [UIColor colorWithHex:0x959595];
        UIColor *selectTextColor = [UIColor colorWithHex:0xf8b22c];
        [tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont systemFontOfSize:11.0], UITextAttributeFont, normalTextColor, UITextAttributeTextColor, nil]
                                  forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            selectTextColor, UITextAttributeTextColor, nil]
                                  forState:UIControlStateSelected];
        
        [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }];
}

@end
