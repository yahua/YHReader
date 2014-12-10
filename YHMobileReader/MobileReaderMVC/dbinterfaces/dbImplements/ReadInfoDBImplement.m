//
//  NSObject+ReadInfoDBImplement.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ReadInfoDBInterface.h"
#import "DBManager.h"


#define kReaderID   10000

@interface ReadInfoImplement : NSObject <ReadInfoDBInterface>

@end


@implementation ReadInfoImplement

/**
 获取阅读信息
 */
- (ReadInfo *)getReadInfo {
    
    ReadInfo *readInfo = [[ReadInfo alloc] init];
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from ReadInfo"]];
        
        if ([result next]) {
            
            readInfo.readerID = [result intForColumn:@"readerID"];
            readInfo.backgroundColorID = [result intForColumn:@"backgroundID"];
            readInfo.fontSize = [result intForColumn:@"fontSize"];
            readInfo.screenLight = [result intForColumn:@"screenLight"];
            readInfo.pageMethod = [result intForColumn:@"pageMethod"];
        }
    }];
    
    return readInfo;
}

- (void)setBackgroundColor:(NSInteger)colorID {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update ReadInfo "
                         "set backgroundID = %d "
                         "where readerID = %d", colorID, kReaderID];
        isOk = [db executeUpdate:sql];
    }];
}

- (void)setFontSize:(NSInteger)fontSize {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update ReadInfo "
                         "set fontSize = %d "
                         "where readerID = %d", fontSize, kReaderID];
        isOk = [db executeUpdate:sql];
    }];
}

- (void)setScreenLight:(NSInteger)screenLight {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update ReadInfo "
                         "set screenLight = %d "
                         "where readerID = %d", screenLight, kReaderID];
        isOk = [db executeUpdate:sql];
    }];
}

- (void)setPageMethod:(NSInteger)pageMethod {
    
    __block BOOL isOk = NO;
    [[DBManager shareDataBase] inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update ReadInfo "
                         "set pageMethod = %d "
                         "where readerID = %d", pageMethod, kReaderID];
        isOk = [db executeUpdate:sql];
    }];
}

@end