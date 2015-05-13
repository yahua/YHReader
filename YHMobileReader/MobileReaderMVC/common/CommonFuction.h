//
//  CommonFuction.h
//  YHMobileReader
//
//  Created by 王时温 on 15-5-10.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFuction : NSObject


+ (NSString*)getLocalPath:(NSString *)fileName;

+ (unsigned long long)fileSizeForPath:(NSString *)path;

@end
