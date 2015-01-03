//
//  UIImageView+Cache.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIImageView+Cache.h"
#import <objc/runtime.h>
#import "YHWebImageManager.h"

@interface UIImageView ()

@property (nonatomic, strong) YHWebImageOperation *operation;
@property (nonatomic, copy) NSString *imageId;

@end

@implementation UIImageView (Cache)

- (void)setImageUrl:(NSString *)url {
    
    if (self.operation) {
        [self.operation cancel];
        self.operation = nil;
    }
    
    __weak UIImageView *wself = self;
    self.imageId = [NSString md5:url];
    self.operation = [[YHWebImageManager sharedInstance] downloadWithUrl:url success:^(id data) {
        self.operation = nil;
        if ([[data lastPathComponent] isEqualToString:self.imageId]) {
            UIImage *image = [UIImage imageWithContentsOfFile:data];
            wself.image = image;
            [wself setNeedsLayout];
        }
    } failuer:^(NSError *msg) {
        self.operation = nil;
    }];
}

#pragma mark - Setter Getter

- (YHWebImageOperation *)operation {
    
    return (YHWebImageOperation *)objc_getAssociatedObject(self, @selector(operation));
}

- (void)setOperation:(YHWebImageOperation *)imageRequestOperation {
    
    objc_setAssociatedObject(self, @selector(operation), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageId {
    
     return (NSString *)objc_getAssociatedObject(self, @selector(imageId));
}

- (void)setImageId:(NSString *)imageId {
    
    objc_setAssociatedObject(self, @selector(imageId), imageId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
