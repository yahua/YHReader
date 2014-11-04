//
//  BookRack.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookRack.h"

@implementation BookRack

- (void)dealloc
{
    self.bookRackName = nil;
    self.booksArray = nil;
    [super dealloc];
}

@end
