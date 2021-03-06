//
//  BookMarkDBInterface.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMarkDBInterface.h"
#import "DBManager.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@interface BookMarkDBImplement : NSObject <BookMarkDBInterface>

@end


@implementation BookMarkDBImplement

/**
 取书签
 */
- (NSArray *)getBookMark:(NSInteger)bookID {
    
    __weak NSMutableArray *markArray = [NSMutableArray array];
    
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        
        
    }];
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        
    
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from BookMark ""where bookID = %d", bookID]];
        
        while ([result next]) {
            
            BookMark *bookMark = [[BookMark alloc] init];
            bookMark.bookID = bookID;
            bookMark.bookMarkID = [result intForColumn:@"bookMarkID"];
            bookMark.bookMarkDes = [result stringForColumn:@"bookMarkDes"];
            bookMark.bookMarkDate = [result stringForColumn:@"bookMarkDate"];
            bookMark.bookProgress = [result doubleForColumn:@"booksProgress"];
            
            [markArray addObject:bookMark];
        }
    }];
     return markArray;
}

/**
 添加书签
 */
- (void)addBookMark:(BookMark *)bookMark {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into BookMark(bookID, bookMarkID, bookMarkDes, bookMarkDate, booksProgress) "
                         "values(%d, %d, '%@', '%@', %f)",  bookMark.bookID, bookMark.bookMarkID, bookMark.bookMarkDes, bookMark.bookMarkDate, bookMark.bookProgress];
        isOk = [db executeUpdate:sql];
    }];
}

/**
 删除书签
 */
- (void)deleteBookMark:(NSInteger)bookMarkID forBookID:(NSInteger)bookID {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:
                         @"delete from BookMark "
                         "where bookID = %d and bookMarkID = %d", bookID, bookMarkID];
        isOk = [db executeUpdate:sql];
    }];
}
@end


