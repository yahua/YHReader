//
//  YHWebImageCache.h
//  YHMobileReader
//
//  Created by 王时温 on 15-1-21.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHWebImageCache : NSObject

+ (YHWebImageCache *)sharedInstance;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;

@end
