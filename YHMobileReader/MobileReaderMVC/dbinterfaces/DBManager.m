//
//  DBManager.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

#define debugMethod(...) NSLog((@"In %s,%s [Line %d] "), __PRETTY_FUNCTION__,__FILE__,__LINE__,##__VA_ARGS__)
static FMDatabase *shareDataBase = nil;
@implementation DBManager

/**
 创建数据库类的单例对象
 
 **/

+ (FMDatabase *)createDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject];
        NSString *file = [path stringByAppendingPathComponent:KdataBaseName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
            NSString *fromFile = [[NSBundle mainBundle] pathForResource:KdataBaseName ofType:nil];
            [[NSFileManager defaultManager] copyItemAtPath:fromFile toPath:file error:nil];
        }
        shareDataBase = [FMDatabase databaseWithPath:file];
        [shareDataBase open];
    });
    return shareDataBase;
}

/**
 创建表
 **/
+ (BOOL)createTable {
    debugMethod();

    BOOL isSucceed = NO;
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        
        //书籍分类表
        NSString *tableClassify = @"create table if not exists BookClassify (classifyID integer primary key not null, classifyName text, bookNum integer)";
        isSucceed = [shareDataBase executeUpdate:tableClassify];
        
        //书架表
        NSString *tableBookRack = @"create table if not exists BookRack (bookRackID integer primary key not null, bookRackName text)";
        isSucceed = [shareDataBase executeUpdate:tableBookRack];
        
        //书签表
        NSString *tableBookMark = @"create table if not exists BookMark (bookID integer, bookMarkID integer, bookMarkDes text, bookMarkDate text, booksProgress float)";
        isSucceed = [shareDataBase executeUpdate:tableBookMark];
        
        //书籍表
        NSString *tableBooks = @"create table if not exists Books (booksID integer primary key not null, bookRackID integer, booksInRackPos integer, booksName text, booksPicName text, booksPath text, booksProgress float)";
        isSucceed = [shareDataBase executeUpdate:tableBooks];
        
        //阅读信息表
        NSString *tableReadInfo = @"create table if not exists ReadInfo (readerID integer primary key not null, backgroundID integer, fontSize integer, screenLight integer, pageMethod integer)";
        isSucceed = [shareDataBase executeUpdate:tableReadInfo];

    }
    return isSucceed;
}

/**
 关闭数据库
 **/
+ (void)closeDataBase {
    if(![shareDataBase close]) {
        NSLog(@"数据库关闭异常，请检查");
        return;
    }
}

@end
