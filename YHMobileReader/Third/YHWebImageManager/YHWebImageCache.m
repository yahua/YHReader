//
//  YHWebImageCache.m
//  YHMobileReader
//
//  Created by 王时温 on 15-1-21.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "YHWebImageCache.h"

@interface YHWebImageCache ()

@property (nonatomic, strong) NSCache *memCache;

@end

@implementation YHWebImageCache

+ (YHWebImageCache *)sharedInstance {
    
    static YHWebImageCache *imageCache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        imageCache = [[YHWebImageCache alloc] init];
    });
    return imageCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memCache = [[NSCache alloc] init];
        self.memCache.name = @"YHWebImageCache";
    }
    return self;
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    
    if (!image || !key) {
        return;
    }
    [self.memCache setObject:image forKey:key cost:image.size.height * image.size.width * image.scale * image.scale];
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key {
    return [self.memCache objectForKey:key];
}

@end
