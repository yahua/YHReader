//
//  DownloadBookInfo.h
//  YHMobileReader
//
//  Created by 王时温 on 15-5-16.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadBookInfo : NSObject

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSString *bookImgUrl;
@property (nonatomic, assign) CGFloat progress;

@end
