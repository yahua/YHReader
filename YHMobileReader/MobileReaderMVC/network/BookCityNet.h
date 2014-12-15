//
//  BookCityNet.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "YHFtpRequestOperation.h"

@interface BookCityNet : NSObject

+ (YHFtpRequestOperation *)getBookTopWithSuccess:(void(^)(NSArray *array))sucessBlock
                                         failuer:(void(^)(NSString *msg))failBlock;

+ (YHFtpRequestOperation *)getImageWithUrl:(NSString *)url
                                 completed:(void(^)(UIImage *image))completed;


@end
