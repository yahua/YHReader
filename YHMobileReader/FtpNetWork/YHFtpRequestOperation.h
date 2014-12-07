//
//  YHFtpRequestOperation.h
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-4.
//
//

#import <Foundation/Foundation.h>

typedef void (^FtpOperationSuccessBlock)  (NSString *msg, id data);
typedef void (^FtpOperationFailuerBlock)  (NSString *msg);
typedef void (^FtpOperationProgressBlock) (long long bytesWritten, long long totalBytesWritten, long long expectedTotalBytes);


@interface YHFtpRequestOperation : NSOperation

- (id)initWithGetUrl:(NSString *)urlString
             success:(FtpOperationSuccessBlock)sucessBlock
             failuer:(FtpOperationFailuerBlock)failBlock;

- (id)initWithGetUrl:(NSString *)urlString
            progress:(FtpOperationProgressBlock)progressBlock
             failuer:(FtpOperationFailuerBlock)failBlock;

@end
