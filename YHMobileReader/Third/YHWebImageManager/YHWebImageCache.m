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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self storeMemoryImage:image forKey:key];
        [self storeDiskImage:image forKey:key];
    });
    
}

- (void)imageFromCacheForKey:(NSString *)key complete:(void(^)(UIImage *image))complete {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self getMemoryImageWithKey:key];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(image);
            });
        }else {
            image = [self getDiskImageWithKey:key];
            if (image) {
                [self storeMemoryImage:image forKey:key];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(image);
            });
        }
    });
}

#pragma mark - Notification

- (void)clearMemory {
    
    [self.memCache removeAllObjects];
}

#pragma mark - Private

- (UIImage *)getMemoryImageWithKey:(NSString *)key {
    
    if (!key) {
        return nil;
    }
    
    return [self.memCache objectForKey:key];
}

- (UIImage *)getDiskImageWithKey:(NSString *)key {
    
    if (!key) {
        return nil;
    }
    
    NSString *cachePath = [self getCachePath];
    NSString *fileName = [NSString md5:key];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    }else {
        return nil;
    }
}

- (void)storeMemoryImage:(UIImage *)image forKey:(NSString *)key {
    
    if (!image || !key) {
        return;
    }
    [self.memCache setObject:image forKey:key cost:image.size.height * image.size.width * image.scale * image.scale];
}

- (void)storeDiskImage:(UIImage *)image forKey:(NSString *)key {
    
    if (!image || !key) {
        return;
    }
    NSString *cachePath = [self getCachePath];
    NSString *fileName = [NSString md5:key];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] createFileAtPath:filePath
                                            contents:UIImageJPEGRepresentation(image, 0.8)
                                          attributes:nil];
}

- (NSString *)getCachePath
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"YahuaImageCache"];
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
		return dataPath;
	}
    
	/* create a new cache directory */
	if ([[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil]) {
		
		return dataPath;
	}
    return nil;
}

@end
