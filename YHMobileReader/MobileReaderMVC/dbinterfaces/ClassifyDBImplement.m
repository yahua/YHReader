//
//  ClassifyDBInterface.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ClassifyDBInterface.h"
#import "DBManager.h"
#import "DBInterfaceFactory.h"

#define kAllBookTag  10000

@interface  ClassifyDBImplement : NSObject <ClassifyDBInterface>

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation ClassifyDBImplement

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

/**
 获取所有分类
 */
- (NSArray *)getAllClassify {
    
    NSMutableArray *allClassifyArray = [NSMutableArray array];
    
    if ([[DBManager createDataBase] open]) {
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:@"select * from BookClassify order by classifyID desc"]];
        
        while ([result next]) {
            
            BookClassify *bookClassify = [[BookClassify alloc] init];
            bookClassify.classifyID = [result intForColumn:@"classifyID"];
            bookClassify.classifyName = [result stringForColumn:@"classifyName"];
            //bookClassify.bookNum = [result intForColumn:@"bookNum"];
            if (bookClassify.classifyID != kAllBookTag) {
                
                bookClassify.bookNum = [[[DBInterfaceFactory bookDBInterface] getBooks:bookClassify.classifyID] count];
            } else {
                
                bookClassify.bookNum = [[[DBInterfaceFactory bookDBInterface] getAllBooks] count];
            }
            
            [allClassifyArray addObject:bookClassify];
        }
    }
    
    return allClassifyArray;
}

/**
 添加书籍分类
 */
- (void)addBookClassify:(BookClassify *)content {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isOk = NO;
        if ([[DBManager createDataBase] open]) {
            
            NSString *sql = [NSString stringWithFormat:@"insert into BookClassify(classifyID, classifyName, bookNum) "
                             "values(%d, '%@', %d)", content.classifyID, content.classifyName, content.bookNum];
            isOk = [[DBManager createDataBase] executeUpdate:sql];
        }
    });
}

- (BookClassify *)getBookClassify:(NSInteger)classifyID {
    
    BookClassify *bookClassify = [[BookClassify alloc] init];
    
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:
                                                           @"select * from BookClassify "
                                                           "where classifyID = %d", classifyID]];
        
        if ([result next]) {
            
            bookClassify.classifyID = [result intForColumn:@"classifyID"];
            bookClassify.classifyName = [result stringForColumn:@"classifyName"];
            bookClassify.bookNum = [[[DBInterfaceFactory bookDBInterface] getBooks:bookClassify.classifyID] count];
        }
    }
    
    return bookClassify;
}

- (void)deleteBookClassify:(NSInteger)classifyID {
    
    dispatch_async(self.serialQueue, ^{
        
        BOOL isOk = NO;
        if ([[DBManager createDataBase] open]) {
            
            NSString *sql = [NSString stringWithFormat:
                             @"delete from BookClassify "
                             "where classifyID = %d", classifyID];
            isOk = [[DBManager createDataBase] executeUpdate:sql];
        }
    });
}

/**
 设置书籍分类的名称
 */
- (void)setBookClassifyName:(NSString *)content forClassifyID:(NSInteger)classifyID {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL isOk = NO;
        if ([[DBManager createDataBase] open]) {
            
            NSString *sql = [NSString stringWithFormat:@"update BookClassify "
                             "set classifyName = '%@'"
                             "where classifyID = %d", content, classifyID];
            isOk = [[DBManager createDataBase] executeUpdate:sql];
        }
    });
}

@end
