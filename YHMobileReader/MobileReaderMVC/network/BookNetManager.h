//
//  BookNetManager.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "YhFtpRequestManager.h"

//#define kFtpBaseUrl  @"ftp://yahua:Y123@192.168.152.1/"
#define kFtpBaseUrl  @"http://192.168.1.104:8000/"

@interface BookNetManager : YhFtpRequestManager

+ (id)sharedInstance;

@end
