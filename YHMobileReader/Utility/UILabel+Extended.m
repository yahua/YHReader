//
//  UILabel+Extended.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UILabel+Extended.h"

@implementation UILabel (Extended)

//宽度一定，计算高度自适应
- (void)resizeForWidth {
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    self.size = size;
}

//高度一定，计算宽度自适应
- (void)resizeForHeight {
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, self.height) lineBreakMode:NSLineBreakByCharWrapping];
    self.size = size;
}

@end
