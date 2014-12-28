//
//  BookCityParser.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-28.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCityParser : NSObject

//返回NetBook的array
+ (NSArray *)parserBookInfo:(NSData *)data;

@end
