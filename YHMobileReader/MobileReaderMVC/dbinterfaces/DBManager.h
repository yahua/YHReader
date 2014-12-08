//
//  DBManager.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define KdataBaseName @"dataBase.db"

@interface DBManager : NSObject

/****/
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)createDataBase;


/**
 *	@brief	关闭数据库
 */
+ (void)closeDataBase;


/**
 *	@brief	创建所有表
 *
 *	@return
 */
+ (BOOL)createTable;

@end
