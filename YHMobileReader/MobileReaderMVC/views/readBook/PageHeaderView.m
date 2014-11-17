//
//  PageHeaderView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-9.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "PageHeaderView.h"
#import "BlockCreateUIDefine.h"

@interface PageHeaderView ()

@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UIButton *catelogButton;
@property (nonatomic, strong) UIButton *daynightButton;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UIImageView *daynightImageView;

@end

@implementation PageHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIButton *backgroundButton = block_createButton(self.bounds, @"", self, @selector(clickBackgroundButton));
    [self addSubview:backgroundButton];
    
    self.returnButton = block_createButton(CGRectMake(0, 0, 40, 40), @"", self, @selector(clickReturnButton:));
    UIImageView *returnImageView = block_createImageView(CGRectMake(10, 8, 25, 25), @"return.png");
    [self.returnButton addSubview:returnImageView];
    [self addSubview:self.returnButton];
    
    self.catelogButton = block_createButton(CGRectMake(self.returnButton.right, 0, 40, 40), @"", self, @selector(clickCatelogButton));
    UIImageView *catelogImageView = block_createImageView(CGRectMake(10, 8, 25, 25), @"home.png");
    [self.catelogButton addSubview:catelogImageView];
    [self addSubview:self.catelogButton];
    
    self.markButton = block_createButton(CGRectMake(0, 0, 40, 40), @"", self, @selector(clickMarkButton));
    self.markButton.right = self.right - 10;
    UIImageView *markImageView = block_createImageView(CGRectMake(10, 8, 25, 25), @"书签.png");
    [self.markButton addSubview:markImageView];
    [self addSubview:self.markButton];
    
    self.daynightButton = block_createButton(CGRectMake(0, 0, 40, 40), @"", self, @selector(clickDaynightButton));
    self.daynightButton.right = self.markButton.left;
    self.daynightImageView = block_createImageView(CGRectMake(10, 8, 25, 25), @"月亮.png");
    [self.daynightButton addSubview:self.daynightImageView];
    [self addSubview:self.daynightButton];
}

- (void)clickBackgroundButton {
    
    
}

- (void)clickReturnButton:(id)sender {
    
    [self.delegate clickReturn];
}

- (void)clickCatelogButton {
    
    [self.delegate clickCatelog];
}

- (void)clickDaynightButton {
    
    self.daynightButton.selected = !self.daynightButton.selected;
    [self.delegate clickDaynight:self.daynightButton.selected];
    if (self.daynightButton.selected) {
        
        self.daynightImageView.image = [UIImage imageNamed:@"太阳.png"];
    }else {
        
        self.daynightImageView.image = [UIImage imageNamed:@"月亮.png"];
    }
}

- (void)clickMarkButton {
    
    [self.delegate clickMark];
}

@end
