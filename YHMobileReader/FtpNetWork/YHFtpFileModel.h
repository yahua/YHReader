//
//  YHFtpFileModel.h
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-7.
//
//

#import <Foundation/Foundation.h>

@interface YHFtpFileModel : NSObject

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) unsigned long long fileSize;

@property (nonatomic, strong) NSDate *fileDate;

@end
