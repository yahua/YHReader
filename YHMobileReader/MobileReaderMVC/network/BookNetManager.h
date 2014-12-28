//
//  BookNetManager.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "YhFtpRequestManager.h"

//#define kFtpBaseUrl  @"ftp://192.168.152.1/"
#define kFtpBaseUrl  @"ftp://yahua:Y123@192.168.1.106/"

@interface BookNetManager : YhFtpRequestManager

+ (id)sharedInstance;

@end
