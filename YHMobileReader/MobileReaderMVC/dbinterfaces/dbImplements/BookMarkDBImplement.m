//
//  BookMarkDBInterface.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMarkDBInterface.h"
#import "DBManager.h"

@interface BookMarkDBImplement : NSObject <BookMarkDBInterface>

@end


@implementation BookMarkDBImplement

/**
 取书签
 */
- (NSArray *)getBookMark:(NSInteger)bookID {
    
    NSMutableArray *markArray = [NSMutableArray array];
    
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:@"select * from BookMark ""where bookID = %d", bookID]];
        
        while ([result next]) {
            
            BookMark *bookMark = [[[BookMark alloc] init] autorelease];
            bookMark.bookID = bookID;
            bookMark.bookMarkID = [result intForColumn:@"bookMarkID"];
            bookMark.bookMarkDes = [result stringForColumn:@"bookMarkDes"];
            bookMark.bookMarkDate = [result stringForColumn:@"bookMarkDate"];
            bookMark.bookProgress = [result doubleForColumn:@"booksProgress"];
            
            [markArray addObject:bookMark];
        }
    }

    
    return markArray;
}

/**
 添加书签
 */
- (void)addBookMark:(BookMark *)bookMark {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into BookMark(bookID, bookMarkID, bookMarkDes, bookMarkDate, booksProgress) "
                         "values(%d, %d, '%@', '%@', %f)",  bookMark.bookID, bookMark.bookMarkID, bookMark.bookMarkDes, bookMark.bookMarkDate, bookMark.bookProgress];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
        
    }
}

/**
 删除书签
 */
- (void)deleteBookMark:(NSInteger)bookMarkID forBookID:(NSInteger)bookID {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:
                         @"delete from BookMark "
                         "where bookID = %d and bookMarkID = %d", bookID, bookMarkID];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
        
    }

}
@end


