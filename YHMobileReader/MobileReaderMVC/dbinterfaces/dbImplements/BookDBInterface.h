//
//  BookDBInterface.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "Books.h"

@protocol BookDBInterface

/**
 获取所有图书
 */
- (NSArray *)getAllBooks;

/**
 获取书架的所有图书
 */
- (NSArray *)getBooks:(NSInteger)bookRackID;

/**
 从表添加一本书籍
 */
- (void)addBook:(Books *)books;

/**
 从表删除一本书籍
 */
- (void)deleteBook:(NSInteger)bookID;

/**
 设置书籍所属书架
 */
- (void)setBookRack:(NSInteger)bookRackID forBookID:(NSInteger)bookID;

/**
 保存书籍的修改
 */
- (void)saveBooksWithRack:(NSInteger)rackID withBooksArray:(NSArray *)booksArray;

/**
 设置书籍在书架中的位置
 */
- (void)setBookInRackPos:(NSInteger)pos withBookID:(NSInteger)bookID;

/**
 设置书籍阅读进度
 */
- (void)setBookProgress:(CGFloat)booksProgress forBookID:(NSInteger)bookID;
/**
 获取书籍阅读进度
 */
- (CGFloat)getBookProgress:(NSInteger)bookID;

@end

