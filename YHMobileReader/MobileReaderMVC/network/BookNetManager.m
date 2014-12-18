//
//  BookNetManager.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookNetManager.h"

@implementation BookNetManager

+ (BookNetManager *)sharedInstance {
    
    static BookNetManager *netManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netManager = [[BookNetManager alloc] initWithBaseURL:[NSURL URLWithString:kFtpBaseUrl]];
    });
    return netManager;
}

#pragma mark OverWrite

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    //别的处理
    
    return self;
}

@end
