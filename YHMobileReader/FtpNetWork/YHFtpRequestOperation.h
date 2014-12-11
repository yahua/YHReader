//
//  YHFtpRequestOperation.h
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-4.
//
//

#import <Foundation/Foundation.h>

typedef void (^FtpOperationSuccessBlock)  (id data);
typedef void (^FtpOperationFailuerBlock)  (NSError *msg);
typedef void (^FtpOperationProgressBlock) (NSInteger bytesWritten, long long totalBytesWritten, long long expectedTotalBytes);


@interface YHFtpRequestOperation : NSOperation

- (id)initWithRequest:(NSURLRequest *)urlRequest;

- (void)setCompletionBlockWithSuccess:(FtpOperationSuccessBlock)success
                              failure:(FtpOperationFailuerBlock)failure;

- (void)setFtpOperationProgressBlock:(FtpOperationProgressBlock)progressBlock;

@end
