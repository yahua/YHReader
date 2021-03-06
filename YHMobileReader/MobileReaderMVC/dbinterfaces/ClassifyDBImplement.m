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
        
        //self.serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

/**
 获取所有分类
 */
- (NSArray *)getAllClassify {
    
    NSMutableArray *allClassifyArray = [NSMutableArray array];
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from BookClassify order by classifyID desc"]];
        
        while ([result next]) {
            
            BookClassify *bookClassify = [[BookClassify alloc] init];
            bookClassify.classifyID = [result intForColumn:@"classifyID"];
            bookClassify.classifyName = [result stringForColumn:@"classifyName"];
            
            NSInteger num = 0;
            NSString *sql = [NSString stringWithFormat:
                             @"select * from Books "
                             "where bookRackID = %d "
                             "order by booksInRackPos", bookClassify.classifyID];
            if (bookClassify.classifyID == kAllBookRackID) {
                sql = [NSString stringWithFormat:@"select * from Books"];
            }
            FMResultSet *resultbookNum = [db executeQuery:sql];
            while ([resultbookNum next]) {
                
                num++;
            }
            bookClassify.bookNum = num;
            
            [allClassifyArray addObject:bookClassify];
        }
    }];

    return allClassifyArray;
}

/**
 添加书籍分类
 */
- (void)addBookClassify:(BookClassify *)content {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into BookClassify(classifyID, classifyName, bookNum) "
                         "values(%d, '%@', %d)", content.classifyID, content.classifyName, content.bookNum];
        isOk = [db executeUpdate:sql];
    }];
}

- (BookClassify *)getBookClassify:(NSInteger)classifyID {
    
    BookClassify *bookClassify = [[BookClassify alloc] init];
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:
                                                                        @"select * from BookClassify "
                                                                        "where classifyID = %d", classifyID]];
        if ([result next]) {
            
            bookClassify.classifyID = [result intForColumn:@"classifyID"];
            bookClassify.classifyName = [result stringForColumn:@"classifyName"];
            bookClassify.bookNum = [[[DBInterfaceFactory bookDBInterface] getBooks:bookClassify.classifyID] count];
        }
    }];

    return bookClassify;
}

- (void)deleteBookClassify:(NSInteger)classifyID {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:
                         @"delete from BookClassify "
                         "where classifyID = %d", classifyID];
        isOk = [db executeUpdate:sql];
    }];
}

/**
 更新书籍分类
 */
- (void)updateBookClassify:(BookClassify *)bookClassify {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        
        BOOL bExits = NO;
        {
            NSString *strSql = [NSString stringWithFormat:@"select 1 from BookClassify where classifyID = %d  ", bookClassify.classifyID];
            FMResultSet *rs = [db executeQuery:strSql];
            bExits = [rs next];
            [rs close];
        }
        
        if (bExits) {
            NSString *sql = [NSString stringWithFormat:@"update BookClassify "
                             "set classifyName = '%@'"
                             "where classifyID = %d", bookClassify.classifyName, bookClassify.classifyID];
            isOk = [db executeUpdate:sql];
        }else {
            [self addBookClassify:bookClassify];
        }
        
    }];

}

@end
