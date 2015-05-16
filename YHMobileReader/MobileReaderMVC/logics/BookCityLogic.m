//
//  BookCityLogic.m
//  YHMobileReader
//
//  Created by 王时温 on 15-5-14.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "BookCityLogic.h"

@implementation BookCityLogic

+ (void)addBookLocal:(NSString *)bookName {
    
    NSString *key = @"BookLocal";
    NSMutableArray *localBookArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    [localBookArray addObject:bookName];
    [[NSUserDefaults standardUserDefaults] setObject:localBookArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)handleBookIslocal:(NetBook *)netBook {
    
    NSString *key = @"BookLocal";
    NSArray *localBookArray = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    for (NSString *loaclBookName in localBookArray) {
        if ([loaclBookName isEqualToString:netBook.bookName]) {
            netBook.isLocal = YES;
            break;
        }else {
            netBook.isLocal = NO;
        }
    }
}

@end
