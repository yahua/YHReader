//
//  RackDBInterface.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//


@protocol RackDBInterface 

/**
 取书架的所有书籍
 */
- (NSArray *)getBooks:(NSInteger)bookRackID;

/**
 添加一本书籍
 */
- (void)addBook:(NSInteger)content forBookRackID:(NSInteger)bookRackID;

/**
 从书架移除一本书籍
 */
- (void)removeBook:(NSInteger)content forBookRackID:(NSInteger)bookRackID;


@end
