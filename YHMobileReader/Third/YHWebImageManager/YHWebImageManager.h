//
//  YHWebImageManager.h
//  YHMobileReader
//
//  Created by 王时温 on 15-1-3.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHWebImageOperation.h"

@interface YHWebImageManager : NSObject

+ (id)sharedInstance;

- (YHWebImageOperation *)downloadWithUrl:(NSString *)urlString
                                 success:(WebImageOperationSuccessBlock)sucessBlock
                                 failuer:(WebImageOperationFailuerBlock)failBlock;

@end
