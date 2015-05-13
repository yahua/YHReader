//
//  YhFtpRequestManager.h
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-6.
//
//

#import <Foundation/Foundation.h>
#import "YHFtpRequestOperation.h"

@interface YhFtpRequestManager : NSObject

@property (nonatomic, strong) NSURL *baseURL;

+ (id)manager;

- (id)initWithBaseURL:(NSURL *)url;

- (YHFtpRequestOperation *)get:(NSString *)urlString
                       success:(FtpOperationSuccessBlock)sucessBlock
                       failuer:(FtpOperationFailuerBlock)failBlock;

- (YHFtpRequestOperation *)download:(NSString *)urlString
                            success:(FtpOperationSuccessBlock)sucessBlock
                            failuer:(FtpOperationFailuerBlock)failBlock
                           progress:(FtpOperationProgressBlock)progressBlock;

@end
