//
//  BookMark.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMark.h"

@implementation BookMark

- (void)dealloc
{
    self.bookMarkDes = nil;
    self.bookMarkDate = nil;
    [super dealloc];
}

@end
