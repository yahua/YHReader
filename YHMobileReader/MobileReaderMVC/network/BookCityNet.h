//
//  BookCityNet.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "YHFtpRequestOperation.h"

@interface BookCityNet : NSObject

+ (YHFtpRequestOperation *)getBookTopInfoWithSuccess:(void(^)(NSArray *array))sucessBlock
                                             failuer:(void(^)(NSString *msg))failBlock;

+ (NSString *)getImageUrl:(NSString *)imageName;


+ (YHFtpRequestOperation *)test:(void(^)(NSArray *array))sucessBlock;

+ (YHFtpRequestOperation *)downloadBookWithBookName:(NSString *)bookName
                                             result:(void(^)(BOOL isSuccess))resultBlock
                                           progress:(void(^)(NSInteger bytesWritten, long long totalBytesWritten, long long expectedTotalBytes))progressBlock;

@end
