//
//  BookCityNet.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookCityNet.h"
#import "BookNetManager.h"
#import "YHFtpLogic.h"
#import "BookCityParser.h"

#import "AFNetworking.h"

@implementation BookCityNet

+ (YHFtpRequestOperation *)getBookTopInfoWithSuccess:(void(^)(NSArray *array))sucessBlock
                                             failuer:(void(^)(NSString *msg))failBlock {
    
    NSString *urlString = @"booksInfo/booksInfo.xml";
    YHFtpRequestOperation *operation = [[BookNetManager sharedInstance] get:urlString success:^(id data) {
        if (sucessBlock) {
            NSArray *netBookArray = [BookCityParser parserBookInfo:data];
            sucessBlock(netBookArray);
        }
    } failuer:^(NSError *msg) {
        if (failBlock) {
            failBlock(@"网络获取失败");
        }
    }];
    
    return operation;
}

+ (YHFtpRequestOperation *)downloadBookWithBookName:(NSString *)bookName
                                             result:(void(^)(BOOL isSuccess))resultBlock
                                           progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long expectedTotalBytes))progressBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"book/%@.txt", bookName];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString relativeToURL:[[BookNetManager sharedInstance] baseURL]]];
    NSString *downloadBookPath = [CommonFuction getLocalPath:bookName];
    //检查文件是否已经下载了一部分
    unsigned long long downloadedBytes = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:downloadBookPath]) {
        //获取已下载的文件长度
        downloadedBytes = [CommonFuction fileSizeForPath:downloadBookPath];
        if (downloadedBytes > 0) {
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [request setValue:requestRange forHTTPHeaderField:@"Range"];
        }
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    YHFtpRequestOperation *operation = [[YHFtpRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:downloadBookPath append:YES]];
    
    [operation setCompletionBlockWithSuccess:^(id data) {
        if (resultBlock) {
            resultBlock(@"YES");
        }
    } failure:^(NSError *msg) {
        if (resultBlock) {
            resultBlock(@"NO");
        }
    }];
    [operation setFtpOperationProgressBlock:progressBlock];
    
    return operation;
    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kFtpBaseUrl]];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    AFHTTPRequestOperation *operation = [manager GET:[[NSString stringWithFormat:@"book/%@.txt", bookName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"YES");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"YES");
//    }];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"11");
//    }];
//    return nil;
}

+ (YHFtpRequestOperation *)test:(void(^)(NSArray *array))sucessBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"key": @"hehe",
                          @"name": @"yahua"};
    [manager GET:@"http://192.168.1.107:8000/booksInfo/booksInfo.xml" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucessBlock) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *netBookArray = [BookCityParser parserBookInfo:responseObject];
            sucessBlock(netBookArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return nil;
}

+ (NSString *)getImageUrl:(NSString *)imageName {
    
    NSString *urlString = [NSString stringWithFormat:@"img/%@.png", imageName];
    urlString = [NSString stringWithFormat:@"%@%@", kFtpBaseUrl, urlString];
    return urlString;
}

@end
