//
//  UILabel+Extended.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extended)

//宽度一定，计算高度自适应
- (void)resizeForWidth;

//高度一定，计算宽度自适应
- (void)resizeForHeight;

@end
