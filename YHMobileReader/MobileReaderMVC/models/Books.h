//
//  books.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 书籍模型
 */
@interface Books : NSObject

/**
 书籍ID
 */
@property (nonatomic, assign) NSInteger booksID;

/**
 所属书架ID
 */
@property (nonatomic, assign) NSInteger bookRackID;

/**
 所属中的位置
 */
@property (nonatomic, assign) NSInteger booksInRackPos;

/**
 书籍图片
 */
@property (nonatomic, copy) NSString *booksPicName;

/**
 书籍名
 */
@property (nonatomic, copy) NSString *booksName;

/**
 书籍路径
 */
@property (nonatomic, copy) NSString *booksPath;

/**
 书籍阅读进度
 */
@property (nonatomic, assign) CGFloat booksProgress;

@end
