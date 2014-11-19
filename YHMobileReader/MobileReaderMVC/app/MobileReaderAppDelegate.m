//
//  MobileReaderAppDelegate.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 wang shiwen. All rights reserved.
//

#import "MobileReaderAppDelegate.h"
#import "SystemLogic.h"
#import "DBManager.h"
#import "UIVCBookRack.h"
#import "DBInterfaceFactory.h"
#import "BookClassify.h"


@implementation MobileReaderAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //创建数据库
    if (![SystemLogic isFirstRunApp]) {
        
        [DBManager createTable];
        [SystemLogic setFirstRunApp:YES];
        
        //测试
//        BookClassify *bookClassify = [[[BookClassify alloc] init] autorelease];
//        bookClassify.classifyID = 10000;
//        bookClassify.classifyName = @"全部";
//        bookClassify.bookNum = 20;
//        [[DBInterfaceFactory classifyDBInterface] addBookClassify:bookClassify];
//
//        bookClassify.classifyID = 2;
//        bookClassify.classifyName = @"经典小说";
//        bookClassify.bookNum = 2;
//        [[DBInterfaceFactory classifyDBInterface] addBookClassify:bookClassify];
//        
//        bookClassify.classifyID = 3;
//        bookClassify.classifyName = @"言情小说";
//        bookClassify.bookNum = 11;
//        [[DBInterfaceFactory classifyDBInterface] addBookClassify:bookClassify];
    }
    //初始化
    [UIScreen initialUIScreenParam];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIVCBookRack *bookRackCon = [[UIVCBookRack alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:bookRackCon];
    self.navigationController.navigationBarHidden = NO;
    
    // Override point for customization after application launch.
    [self.window addSubview:self.navigationController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
