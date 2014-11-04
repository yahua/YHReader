//
//  BookClassify.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 书籍分类模型
 */
@interface BookClassify : NSObject

/**
 书籍分类ID
 */
@property (nonatomic, assign) NSInteger classifyID;

/**
 书籍分类名称
 */
@property (nonatomic, copy) NSString *classifyName;


/**
 书籍分类包含书籍数量
 */
@property (nonatomic, assign) NSInteger bookNum;

@end
