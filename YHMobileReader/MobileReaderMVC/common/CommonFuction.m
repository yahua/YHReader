//
//  CommonFuction.m
//  YHMobileReader
//
//  Created by 王时温 on 15-5-10.
//  Copyright (c) 2015年 压花. All rights reserved.
//

#import "CommonFuction.h"

@implementation CommonFuction

+ (NSString*)getLocalPath:(NSString *)fileName {
    
	NSString *voicePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/BookRec"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:voicePath]) {
		[fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
		NSLog(@"Failed to creating cache folder.");
	}
    
    NSString *rootPath = [NSString stringWithFormat:@"%@/%@", voicePath,[NSString md5:fileName]];
    
    return rootPath;
}

+ (unsigned long long)fileSizeForPath:(NSString *)path {
    
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

@end
