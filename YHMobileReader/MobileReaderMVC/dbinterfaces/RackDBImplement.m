//
//  RackDBInterface.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "RackDBInterface.h"
#import "DBManager.h"

@interface  RackDBImplement  : NSObject <RackDBInterface>

@end

@implementation RackDBImplement

/**
 取书架的所有书籍
 */
- (NSArray *)getBooks:(NSInteger)bookRackID {
    
    __block NSMutableArray *booksArray = nil;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:
                                                                        @"select * from BookRack "
                                                                        "where bookRackID = %d", bookRackID]];
        
        if ([result next]) {
            
            booksArray = [result objectForColumnName:@"booksArray"];
        }
    }];

    return booksArray;
}

/**
 添加一本书籍
 */
- (void)addBook:(NSInteger)content forBookRackID:(NSInteger)bookRackID {
    
//    BOOL isOk = NO;
//    if ([[DBManager createDataBase] open]) {
//        
//        //NSMutableArray *bookArray = [self getBooks:bookRackID];
//        [bookArray addObject:[NSNumber numberWithInt:content]];
//        
//        NSString *sql = [NSString stringWithFormat:@"update BookClassify "
//                         "set booksArray = '%@'"
//                         "where bookRackID = %d", bookArray, bookRackID];
//        
//        isOk = [[DBManager createDataBase] executeUpdate:sql];
//        [[DBManager createDataBase] close];
//    }
}

/**
 从书架移除一本书籍
 */
- (void)removeBook:(NSInteger)content forBookRackID:(NSInteger)bookRackID {
    
//    BOOL isOk = NO;
//    if ([[DBManager createDataBase] open]) {
//        
//        NSMutableArray *bookArray = [self getBooks:bookRackID];
//        
//        id removeBook = nil;
//        for (NSNumber *number in bookArray) {
//            
//            if ([number intValue] == content) {
//                
//                removeBook = number;
//                break;
//            }
//        }
//        
//        if (removeBook) {
//            
//            [bookArray removeObject:removeBook];
//            NSString *sql = [NSString stringWithFormat:@"update BookClassify "
//                             "set booksArray = '%@'"
//                             "where bookRackID = %d", bookArray, bookRackID];
//            isOk = [[DBManager createDataBase] executeUpdate:sql];
//        }
//        
//        [[DBManager createDataBase] close];
//    }
}


@end
