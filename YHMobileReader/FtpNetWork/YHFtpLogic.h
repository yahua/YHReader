//
//  YHFtpLogic.h
//  SimpleFTPSample
//
//  Created by 王时温 on 14-12-7.
//
//

#import <Foundation/Foundation.h>
#import "YHFtpFileModel.h"

@interface YHFtpLogic : NSObject

+ (NSArray *)parserFileModelWithData:(NSData *)data;

+ (NSString *)stringForFileSize:(unsigned long long)size;

@end
