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

+ (id)manager;

- (id)initWithBaseURL:(NSURL *)url;

- (YHFtpRequestOperation *)get:(NSString *)urlString
                       success:(FtpOperationSuccessBlock)sucessBlock
                       failuer:(FtpOperationFailuerBlock)failBlock;


@end
