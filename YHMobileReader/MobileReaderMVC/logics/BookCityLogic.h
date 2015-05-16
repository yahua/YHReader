//
//  BookCityLogic.h
//  YHMobileReader
//
//  Created by 王时温 on 15-5-14.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetBook.h"

@interface BookCityLogic : NSObject

/**
 下载成功，保存本地
 */
+ (void)addBookLocal:(NSString *)bookName;

/**
 判断book是否已下载
 */
+ (void)handleBookIslocal:(NetBook *)netBook;

@end
