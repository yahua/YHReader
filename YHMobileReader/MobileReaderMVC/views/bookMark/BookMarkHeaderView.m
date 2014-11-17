//
//  BookMarkHeaderView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-14.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMarkHeaderView.h"
#import "BlockCreateUIDefine.h"

@implementation BookMarkHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    UIButton *returnButton = block_createButton(CGRectMake(10, 8, 25, 25), @"return.png", self, @selector(clickReturnButton));
    [self addSubview:returnButton];
    
    self.bookNameLabel = block_createLabel([UIColor blackColor], CGRectMake(returnButton.right + 5, 0, 150, 44), 20);
    [self addSubview:self.bookNameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
    [self addSubview:lineView];
}

- (void)clickReturnButton {
    
    [self.delegate clickReturnButton];
}

@end
