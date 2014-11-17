//
//  BookRack.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 书架模型
 */
@interface BookRack : NSObject

/**
 书架ID （分类ID）
 */
@property (nonatomic, assign) NSInteger bookRackID;

/**
 书架名  （分类名）
 */
@property (nonatomic, copy) NSString *bookRackName;

/**
 书架包含书籍的数组
 */
@property (nonatomic, strong) NSArray *booksArray;

@end
