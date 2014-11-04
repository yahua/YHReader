//
//  SystemLogic.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "SystemLogic.h"

@implementation SystemLogic

//保存是否第一次运行程序
+ (BOOL)isFirstRunApp {
    
    NSString *storedName = @"FirstRunApp";
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:storedName];
    return isFirst;
}

+ (void)setFirstRunApp:(BOOL)isFirst {
    
    NSString *storedName = @"FirstRunApp";
    [[NSUserDefaults standardUserDefaults] setBool:isFirst forKey:storedName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
