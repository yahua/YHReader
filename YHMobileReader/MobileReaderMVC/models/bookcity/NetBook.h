//
//  NetBook.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBook : NSObject <NSCoding>

@property (nonatomic, copy) NSString *bookName;

@property (nonatomic, copy) NSString *bookImageName;

@property (nonatomic, copy) NSString *bookSize;

#pragma mark -
#pragma mark 非服务端信息

@property (nonatomic, assign) BOOL isLocal;

@end
