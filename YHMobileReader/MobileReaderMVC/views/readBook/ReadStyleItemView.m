//
//  ReadStyleItemView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-12.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ReadStyleItemView.h"
#import "BlockCreateUIDefine.h"

#define kLabelBaseTag  100000
#define kButtonBaseTag 200000

@interface ReadStyleItemView ()

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, assign) NSInteger itemCount;
@property(nonatomic, strong) UIColor *selectedColor;

@end

@implementation ReadStyleItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectedColor = [UIColor colorWithHex:0x80644e];
        self.selectedIndex = 1;
        self.itemCount = 3;
        
        [self setClipsToBounds:YES];
        self.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        
        [self initSubViews];
    }
    return self;
}

- (void)changeSelectedIndex:(NSInteger)index {
    
    self.selectedIndex = index;
    [self changeItemState];
}

- (void)initSubViews {
    
    CGFloat buttonWidth = self.width/self.itemCount;
    CGFloat left = 0;
    
    NSArray *tittleArray = @[@"仿真", @"水平", @"垂直"];
    for (int i=1; i<=self.itemCount; i++) {
        
        UIButton *button = block_createButton(CGRectMake(left, 0, buttonWidth, self.height),
                                              @"",
                                              self,
                                              @selector(buttonClick:));
        
        UILabel *lable = block_createLabel(self.selectedColor,
                                           button.frame,
                                           15);
        lable.text = [tittleArray objectAtIndex:i-1];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = kLabelBaseTag +i;
        button.tag = kButtonBaseTag +i;
        lable.top -=0.5;
        
        [self addSubview:lable];
        [self addSubview:button];
        
        left += button.width;
        
        if( i != self.itemCount) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.height)];
            [lineView setBackgroundColor:self.selectedColor];
            [lineView setLeft:button.right -0.5];
            [self addSubview:lineView];
        }
    }
    
    for (int i=1; i<=self.itemCount; i++) {
        
        UILabel *label = (UILabel *)[self viewWithTag:kLabelBaseTag +i];
        [self sendSubviewToBack:label];
    }
}

- (void)changeItemState {
    
    for (int i=1; i<=self.itemCount; i++) {
        
        UILabel *label = (UILabel *)[self viewWithTag:kLabelBaseTag +i];
        
        if (i == self.selectedIndex) {
            [label setBackgroundColor:self.selectedColor];
            [label setTextColor:[UIColor whiteColor]];
        } else {
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextColor:self.selectedColor];
        }
    }
    
    if (self.delegate) {
        [self.delegate changeItem:self.selectedIndex];
    }
}

#pragma mark -
#pragma mark ButtonEvent

- (void)buttonClick:(id)sender {
    
    NSInteger selectedIndex = ((UIButton *)sender).tag - kButtonBaseTag;
    
    if (self.selectedIndex != selectedIndex) {
        self.selectedIndex = selectedIndex;
        [self changeItemState];
    }
}

@end
