//
//  UIImageView+Cache.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIImageView+Cache.h"
#import "YhFtpRequestManager.h"
#import <objc/runtime.h>

@interface UIImageView ()

@property (nonatomic, strong) YHFtpRequestOperation *operation;

@end

@implementation UIImageView (Cache)

- (void)setImageUrl:(NSString *)url {
    
    if (self.operation) {
        [self.operation cancel];
        self.operation = nil;
    }
    
    __weak UIImageView *wself = self;
    self.operation = [[YhFtpRequestManager manager] get:url success:^(id data) {
        self.operation = nil;
        UIImage *image = [UIImage imageWithData:data];
        wself.image = image;
        [wself setNeedsLayout];
    } failuer:^(NSError *msg) {
        self.operation = nil;
    }];
}

- (YHFtpRequestOperation *)operation {
    
    return (YHFtpRequestOperation *)objc_getAssociatedObject(self, @selector(operation));
}

- (void)setOperation:(YHFtpRequestOperation *)imageRequestOperation {
    
    objc_setAssociatedObject(self, @selector(operation), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
