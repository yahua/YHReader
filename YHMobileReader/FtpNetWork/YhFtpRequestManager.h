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

+ (YhFtpRequestManager *)shareInstance;

- (YHFtpRequestOperation *)get:(NSString *)urlString
                       success:(FtpOperationSuccessBlock)sucessBlock
                       failuer:(FtpOperationFailuerBlock)failBlock;


- (YHFtpRequestOperation *)get:(NSString *)urlString
                      progress:(FtpOperationProgressBlock)progressBlock
                       failuer:(FtpOperationFailuerBlock)failBlock;

@end
