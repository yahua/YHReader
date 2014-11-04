//
//  ClassifyDBInterface.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookClassify.h"

@protocol  ClassifyDBInterface

/**
 获取所有分类
 */
- (NSArray *)getAllClassify;

/**
  添加书籍分类
 */
- (void)addBookClassify:(BookClassify *)content;
- (BookClassify *)getBookClassify:(NSInteger)classifyID;
- (void)deleteBookClassify:(NSInteger)classifyID;

/**
 设置书籍分类的名称
 */
- (void)setBookClassifyName:(NSString *)content forClassifyID:(NSInteger)classifyID;

@end 

