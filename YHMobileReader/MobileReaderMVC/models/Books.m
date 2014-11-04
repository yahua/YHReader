//
//  books.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-16.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "Books.h"


@implementation Books

- (void)dealloc
{
    self.booksName = nil;
    self.booksPicName = nil;
    self.booksPath = nil;
    [super dealloc];
}

@end
