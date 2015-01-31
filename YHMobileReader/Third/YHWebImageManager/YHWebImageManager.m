//
//  YHWebImageManager.m
//  YHMobileReader
//
//  Created by 王时温 on 15-1-3.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "YHWebImageManager.h"
#import "YHWebImageCache.h"

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
    
    YHWebImageOperation *operation = nil;
    [[YHWebImageCache sharedInstance] imageFromCacheForKey:urlString complete:^(UIImage *image) {
        if (image) {
            if (sucessBlock) {
                sucessBlock(image, [NSURL URLWithString:urlString]);
            }
        }else {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [self imageRequestOperationWithRequest:request sucess:^(UIImage *image, NSURL *url) {
                if (sucessBlock) {
                    sucessBlock(image, url);
                }
                if (image) {
                    [[YHWebImageCache sharedInstance] storeImage:image forKey:urlString];
                }
            } failure:failBlock];
            [self.operationQueue addOperation:operation];
        }
    }];
    
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
