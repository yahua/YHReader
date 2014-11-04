//
//  SystemLogic.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemLogic : NSObject

//保存是否第一次运行程序
+ (BOOL)isFirstRunApp; 
+ (void)setFirstRunApp:(BOOL)isFirst;

@end
