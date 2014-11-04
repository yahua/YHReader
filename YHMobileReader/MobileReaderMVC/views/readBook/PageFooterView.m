//
//  PageFooterView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "PageFooterView.h"
#import "BlockCreateUIDefine.h"


@interface PageFooterView ()

//进度条
@property (nonatomic, assign) UISlider *mSlider;

@property (nonatomic, assign) UIButton *popView;

//点击弹出设置按钮
@property (nonatomic, assign) UIButton *settingButton;

@end

@implementation PageFooterView

- (id)initWithFrame:(CGRect)frame withProgress:(CGFloat)progress
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews:progress];
    }
    return self;
}

- (void)initSubviews:(CGFloat)progress {
    
    UIButton *backgroundButton = block_createButton(self.bounds, @"", self, @selector(clickBackgroundButton));
    [self addSubview:backgroundButton];
    
    self.mSlider = [[[UISlider alloc]initWithFrame:CGRectMake(25, 20, 220, 10)] autorelease];
    self.mSlider.minimumValue = 0;
    self.mSlider.maximumValue = 1;
    self.mSlider.value = progress;
    [self.mSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.mSlider addTarget:self action:@selector(beginUpdateValue:) forControlEvents:UIControlEventTouchDown];
    [self.mSlider addTarget:self action:@selector(endupdateValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.mSlider addTarget:self action:@selector(endupdateValue:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:self.mSlider];
    
    self.popView = block_createButton(CGRectMake(self.mSlider.left, self.mSlider.top -15, 40, 15),nil,self,@selector(updateValue:));
    self.popView.centerX = self.mSlider.left;
    self.popView.layer.cornerRadius = 3;
    self.popView.backgroundColor = [UIColor blackColor];
    self.popView.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [self.popView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.popView setAlpha:0.0f];
    [self addSubview:self.popView];
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton.frame = CGRectMake(0, 10, 40, 40);
    self.settingButton.right = self.width;
    [self.settingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.settingButton];
    
    UIImageView *imageView = block_createImageView(CGRectMake(0, 0, 25, 25), @"设置.png");
    [self.settingButton addSubview:imageView];
}

- (void)beginUpdateValue:(id)slider {
    
    [self updateValue:slider];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.popView setAlpha:0.7f];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)endupdateValue:(id)slider {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.popView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理 跳转到这个进度
                         CGFloat value = self.mSlider.value;
                         [self.delegate changeProgress:value];
                     }];
}

- (void)updateValue:(id)slider {
    
    
    UIImageView *imageView = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7? [self.mSlider.subviews objectAtIndex:1]:[self.mSlider.subviews objectAtIndex:2];
    
    
    CGRect theRect = [self convertRect:imageView.frame fromView:imageView.superview];
    [self.popView setFrame:CGRectMake(theRect.origin.x, theRect.origin.y-self.popView.height, self.popView.width, self.popView.height)];
    self.popView.centerX = theRect.origin.x + theRect.size.width/2.0;
    
    CGFloat v = self.mSlider.value * 100;
    [self.popView setTitle:[NSString stringWithFormat:@"%.2f%@", v, @"%"] forState:UIControlStateNormal];
}

- (void)clickSettingButton {
    
    [self.delegate showSettingView];
}

- (void)clickBackgroundButton {
    
    
}

@end
