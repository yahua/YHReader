//
//  DownloadBookManager.h
//  YHMobileReader
//
//  Created by 王时温 on 15-5-16.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadBookInfo.h"

@interface DownloadBookManager : NSObject

+ (DownloadBookManager *)shareInstance;

- (DownloadBookInfo *)addDownloadBookTaskL:(NSString *)bookName
                              bookImageUrl:(NSString *)imageUrl
                               resultBlock:(void(^) (BOOL isSuccess))resultBlock;

@end
