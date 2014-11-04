//
//  BookDBInterface.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookDBInterface.h"
#import "DBManager.h"
#import "DBInterfaceFactory.h"

@interface BookDBImplement : NSObject <BookDBInterface>

@end

@implementation BookDBImplement

/**
 获取所有图书
 */
- (NSArray *)getAllBooks {
    
    NSMutableArray *booksArray = [NSMutableArray array];
    
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:
                                                           @"select * from Books"]];
        
        while ([result next]) {
            
            Books *books = [[[Books alloc] init] autorelease];
            books.booksID = [result intForColumn:@"booksID"];
            books.bookRackID = [result intForColumn:@"bookRackID"];
            books.booksName = [result stringForColumn:@"booksName"];
            books.booksPicName = [result stringForColumn:@"booksPicName"];
            books.booksPath = [result stringForColumn:@"booksPath"];
            books.booksProgress = [result doubleForColumn:@"booksProgress"];
            books.booksInRackPos = [result intForColumn:@"booksInRackPos"];
            
            [booksArray addObject:books];
        }
    }

    return booksArray;
}

/**
 获取书架的所有图书
 */
- (NSArray *)getBooks:(NSInteger)bookRackID {
    
    NSMutableArray *booksArray = [NSMutableArray array];
    
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:
                                                           @"select * from Books "
                                                           "where bookRackID = %d "
                                                            "order by booksInRackPos", bookRackID]];

        while ([result next]) {
            
            Books *books = [[[Books alloc] init] autorelease];
            books.booksID = [result intForColumn:@"booksID"];
            books.bookRackID = bookRackID;
            books.booksName = [result stringForColumn:@"booksName"];
            books.booksPicName = [result stringForColumn:@"booksPicName"];
            books.booksPath = [result stringForColumn:@"booksPath"];
            books.booksProgress = [result doubleForColumn:@"booksProgress"];
            books.booksInRackPos = [result intForColumn:@"booksInRackPos"];
            
            [booksArray addObject:books];
        }
    }
    
    return booksArray;
}

/**
 从表添加一本书籍
 */
- (void)addBook:(Books *)books {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into Books(booksID, booksName, booksPath, booksProgress) "
                         "values(%d, '%@', '%@', %f)", books.booksID, books.booksName, books.booksPath, books.booksProgress];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
        
    }
}

/**
 从表删除一本书籍
 */
- (void)deleteBook:(NSInteger)bookID {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:
                         @"delete from Books "
                         "where booksID = %d", bookID];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
    }
}

/**
 设置书籍所属书架
 */
- (void)setBookRack:(NSInteger)bookRackID forBookID:(NSInteger)bookID {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:@"update Books "
                         "set bookRackID = %d "
                         "where booksID = %d", bookRackID, bookID];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
        
    }
}

/**
 保存书籍的修改
 */
- (void)saveBooksWithRack:(NSInteger)rackID withBooksArray:(NSArray *)booksArray {
    
    for (NSInteger index=0; index<[booksArray count]; index++) {
        
        Books *books = [booksArray objectAtIndex:index];
        
        NSString *sql = [NSString stringWithFormat:@"update Books "
                         "set booksInRackPos = %d "
                         "where booksID = %d and bookRackID = %d", index, books.booksID, rackID];
        [[DBManager createDataBase] executeUpdate:sql];
    }
}

- (void)setBookInRackPos:(NSInteger)pos withBookID:(NSInteger)bookID {
    
    NSString *sql = [NSString stringWithFormat:@"update Books "
                     "set booksInRackPos = %d "
                     "where booksID = %d", pos, bookID];
    [[DBManager createDataBase] executeUpdate:sql];
}

- (NSInteger)getBookInRackPos:(NSInteger)booksID {
    
    NSInteger pos = 0;
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:
                                                                        @"select * from Books "
                                                                        "where booksID = %d", booksID]];
        if ([result next]) {
            
            pos = [result doubleForColumn:@"booksInRackPos"];
        }
        
    }
    return pos;
}

/**
 设置书籍阅读进度
 */
- (void)setBookProgress:(CGFloat)booksProgress forBookID:(NSInteger)bookID {
    
    BOOL isOk = NO;
    if ([[DBManager createDataBase] open]) {
        
        NSString *sql = [NSString stringWithFormat:@"update Books "
                         "set booksProgress = %f "
                         "where booksID = %d", booksProgress, bookID];
        isOk = [[DBManager createDataBase] executeUpdate:sql];
    }
}


/**
 获取书籍阅读进度
 */
- (CGFloat)getBookProgress:(NSInteger)bookID {
    
    CGFloat bookProgress = 0;
    if ([[DBManager createDataBase] open]) {
        
        FMResultSet *result = [[DBManager createDataBase] executeQuery:[NSString stringWithFormat:
                                                           @"select * from Books "
                                                           "where booksID = %d", bookID]];
        if ([result next]) {
            
            bookProgress = [result doubleForColumn:@"booksProgress"];
        }
        
    }
    
    return bookProgress;
}

@end
