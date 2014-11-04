//
//  BookMark.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 书签模型：每本书都有一组书签
 */
@interface BookMark : NSObject

/**
 书籍ID
 */
@property (nonatomic, assign) NSInteger bookID;

/**
 书签ID
 */
@property (nonatomic, assign) NSInteger bookMarkID;

/**
 书签描述
 */
@property (nonatomic, copy) NSString *bookMarkDes;

/**
 书签日期
 */
@property (nonatomic, copy) NSString *bookMarkDate;

@property (nonatomic, assign) CGFloat bookProgress;

@end
