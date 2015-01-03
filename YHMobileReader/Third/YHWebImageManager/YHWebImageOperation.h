//
//  YHWebImageOperation.h
//  YHMobileReader
//
//  Created by 王时温 on 15-1-2.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebImageOperationSuccessBlock)  (id data);
typedef void (^WebImageOperationFailuerBlock)  (NSError *msg);

@interface YHWebImageOperation : NSOperation

- (id)initWithRequest:(NSURLRequest *)urlRequest;

- (void)setCompletionBlockWithSuccess:(WebImageOperationSuccessBlock)success
                              failure:(WebImageOperationFailuerBlock)failure;

@end
