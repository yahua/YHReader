//
//  DownloadBookManager.m
//  YHMobileReader
//
//  Created by 王时温 on 15-5-16.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "DownloadBookManager.h"
#import "BookCityNet.h"

@interface DownloadBookManager ()

@property (nonatomic, strong) NSMutableArray *downloadList;

@end

@implementation DownloadBookManager

+ (DownloadBookManager *)shareInstance {
    
    static DownloadBookManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DownloadBookManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}


- (DownloadBookInfo *)addDownloadBookTaskL:(NSString *)bookName
                              bookImageUrl:(NSString *)imageUrl
                               resultBlock:(void(^) (BOOL isSuccess))resultBlock {
    
    DownloadBookInfo *downloadTask = [[DownloadBookInfo alloc] init];
    downloadTask.bookName = bookName;
    downloadTask.bookImgUrl = imageUrl;
    
    NSString *downloadPath = [CommonFuction getLocalPath:bookName];
    unsigned long long downloadedBytes = [CommonFuction fileSizeForPath:downloadPath];
    [BookCityNet downloadBookWithBookName:bookName result:^(BOOL isSuccess) {
        //生成一个books
        
        
        if (resultBlock) {
            resultBlock(isSuccess);
        }
    } progress:^(NSInteger bytesWritten, long long totalBytesWritten, long long expectedTotalBytes) {
        downloadTask.progress = (float)(totalBytesWritten+downloadedBytes)/(expectedTotalBytes+downloadedBytes);
    }];
    
    [self.downloadList addObject:downloadTask];
    return downloadTask;
}

@end
