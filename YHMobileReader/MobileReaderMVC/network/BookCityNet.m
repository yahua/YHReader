//
//  BookCityNet.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookCityNet.h"
#import "BookNetManager.h"
#import "YHFtpLogic.h"

@implementation BookCityNet

+ (YHFtpRequestOperation *)getBookTopWithSuccess:(void(^)(NSArray *array))sucessBlock
                                         failuer:(void(^)(NSString *msg))failBlock {
    
    NSString *urlString = @"book/";
    YHFtpRequestOperation *operation = [[BookNetManager sharedInstance] get:urlString success:^(id data) {
        if (sucessBlock) {
            NSArray *array = [YHFtpLogic parserFileModelWithData:data];
            sucessBlock(array);
        }
    } failuer:^(NSError *msg) {
        if (failBlock) {
            failBlock(@"网络获取失败");
        }
    }];
    
    return operation;
}

@end
