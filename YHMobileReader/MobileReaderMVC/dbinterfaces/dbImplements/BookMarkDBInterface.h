//
//  BookMarkDBInterface.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMark.h"

@protocol BookMarkDBInterface

/**
 取书签
 */
- (NSArray *)getBookMark:(NSInteger)bookID;

/**
 添加书签
 */
- (void)addBookMark:(BookMark *)bookMark;

/**
 删除书签
 */
- (void)deleteBookMark:(NSInteger)bookMarkID forBookID:(NSInteger)bookID;

@end
