//
//  YHWebImageManager.m
//  YHMobileReader
//
//  Created by 王时温 on 15-1-3.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "YHWebImageManager.h"

@interface YHWebImageManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation YHWebImageManager

+ (YHWebImageManager *)sharedInstance {
    
    static YHWebImageManager *netManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netManager = [[YHWebImageManager alloc] init];
    });
    return netManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (YHWebImageOperation *)downloadWithUrl:(NSString *)urlString
                                 success:(WebImageOperationSuccessBlock)sucessBlock
                                 failuer:(WebImageOperationFailuerBlock)failBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    YHWebImageOperation *operation = [self imageRequestOperationWithRequest:request sucess:sucessBlock failure:failBlock];
    [self.operationQueue addOperation:operation];
    
    return operation;
}


- (YHWebImageOperation *)imageRequestOperationWithRequest:(NSURLRequest *)request
                                                   sucess:(WebImageOperationSuccessBlock)sucessBlock
                                                  failure:(WebImageOperationFailuerBlock)failBlock {
    
    YHWebImageOperation *operation = [[YHWebImageOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:sucessBlock failure:failBlock];
    
    return operation;
}

@end
