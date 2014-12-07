//
//  YhFtpRequestManager.m
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-6.
//
//

#import "YhFtpRequestManager.h"

#define kFtpBaseUrl  @"ftp://192.168.152.1/"

@interface YhFtpRequestManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation YhFtpRequestManager

+ (YhFtpRequestManager *)shareInstance {

    static YhFtpRequestManager *ftpRequestManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ftpRequestManager = [[YhFtpRequestManager alloc] init];
        ftpRequestManager.operationQueue = [[NSOperationQueue alloc] init];
    });
    return ftpRequestManager;
}


- (YHFtpRequestOperation *)get:(NSString *)urlString
                       success:(FtpOperationSuccessBlock)sucessBlock
                       failuer:(FtpOperationFailuerBlock)failBlock {
    
    YHFtpRequestOperation *operation = [[YHFtpRequestOperation alloc] initWithGetUrl:[NSString stringWithFormat:kFtpBaseUrl@"%@", urlString] success:sucessBlock failuer:failBlock];
    [self.operationQueue addOperation:operation];
    return operation;
}


- (YHFtpRequestOperation *)get:(NSString *)urlString
                      progress:(FtpOperationProgressBlock)progressBlock
                       failuer:(FtpOperationFailuerBlock)failBlock {
    
    YHFtpRequestOperation *operation = [[YHFtpRequestOperation alloc] initWithGetUrl:[NSString stringWithFormat:kFtpBaseUrl@"%@", urlString] progress:progressBlock failuer:failBlock];
    [self.operationQueue addOperation:operation];
    return operation;
}

@end
