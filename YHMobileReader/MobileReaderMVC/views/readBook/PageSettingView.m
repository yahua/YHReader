//
//  PageSettingView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-12.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "PageSettingView.h"
#import "BlockCreateUIDefine.h"
#import "ReadStyleItemView.h"
#import "ReadInfoManager.h"

#define kBackgroundColorTag   10000

@interface PageSettingView () <
ReadStyleItemViewDelegate>

@property (nonatomic, assign) UISlider *lightSlider;

@end

@implementation PageSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    //背景按钮点击隐藏界面
    UIButton *backgroundButton = block_createButton(self.bounds, @"", self, @selector(clickBackgroundButton));
    [self addSubview:backgroundButton];
    
    UIButton *settingView = [[[UIButton alloc] initWithFrame:CGRectMake(53, 0, 260, 215)] autorelease];
    [settingView addTarget:self action:@selector(clickSettingView) forControlEvents:UIControlEventTouchUpInside];
    settingView.bottom = self.height - kUIScreen_BottomBarHeight;
    settingView.backgroundColor = [UIColor colorWithHex:0xf2efe8];
    settingView.layer.cornerRadius = 8;
    settingView.layer.borderWidth = 1;
    settingView.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
    [self addSubview:settingView];
    
    UIView *lightView = [self createBrightView];
    [settingView addSubview:lightView];
    
    //字号
    UIButton *lessButton = block_createButton(CGRectMake(10, lightView.bottom + 12, 115, 35), @"", self, @selector(clickLessButton));
    [lessButton setTitle:@"A-" forState:UIControlStateNormal];
    [lessButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lessButton.layer.cornerRadius = 8;
    lessButton.layer.borderWidth = 1;
    lessButton.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
    [settingView addSubview:lessButton];
    
    UIButton *addButton = block_createButton(CGRectMake(lessButton.right + 10, lightView.bottom + 12, 115, 35), @"", self, @selector(clickAddButton));
    [addButton setTitle:@"A+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addButton.layer.cornerRadius = 8;
    addButton.layer.borderWidth = 1;
    addButton.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
    [settingView addSubview:addButton];
    
    ReadStyleItemView *readStyleItemView = [[[ReadStyleItemView alloc] initWithFrame:CGRectMake(10, addButton.bottom + 12, 240, 35)] autorelease];
    readStyleItemView.delegate = self;
    [readStyleItemView changeSelectedIndex:[ReadInfoManager shareReadInfoManager].pageMethod + 1];
    [settingView addSubview:readStyleItemView];
    
    [settingView addSubview:[self createBackgroundColorView:readStyleItemView.bottom + 12]];
}

- (UIView *)createBrightView {
    
    UIView *lightView = [[UIView alloc] initWithFrame:CGRectMake(10, 12, 240, 50)];
    lightView.backgroundColor = [UIColor clearColor];
    lightView.layer.cornerRadius = 8;
    lightView.layer.borderWidth = 1;
    lightView.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
    
    UILabel *lowLabel = block_createLabel([UIColor blackColor], CGRectMake(0, 13, 21, 21), 21);
    lowLabel.textAlignment = NSTextAlignmentCenter;
    lowLabel.text = @"-";
    [lightView addSubview:lowLabel];
    
    self.lightSlider = [[[UISlider alloc]initWithFrame:CGRectMake(21, 20, 191, 10)] autorelease];
    self.lightSlider.minimumValue = 0;
    self.lightSlider.maximumValue = 100;
    self.lightSlider.value = [ReadInfoManager shareReadInfoManager].light;
    [self.lightSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [lightView addSubview:self.lightSlider];
    
    UILabel *highLabel = block_createLabel([UIColor colorWithHex:0x000000 alpha:0.6], CGRectMake(self.lightSlider.right, 9, 28, 28), 28);
    highLabel.textAlignment = NSTextAlignmentCenter;
    highLabel.text = @"+";
    [lightView addSubview:highLabel];
    
    return lightView;
}

- (UIView *)createBackgroundColorView:(NSInteger)point_y {
    
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, point_y, 260, 35)] autorelease];
    
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat padding = 33;
    
    NSArray *colorArray = @[[UIColor colorWithHex:0xeff2eb], [UIColor colorWithHex:0xf4ecd7], [UIColor colorWithHex:0xbfd6c2], [UIColor colorWithHex:0x1a2020]];
    for (NSInteger i=0; i<4; i++) {
        
        UIButton *button = block_createButton(CGRectMake(x, y, 35, 35), @"", self, @selector(clickColorButton:));
        button.tag = i + kBackgroundColorTag;
        button.backgroundColor = [colorArray objectAtIndex:i];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHex:0xc7c4bd].CGColor;
        [view addSubview:button];
        
        x += 35 + padding;
    }
    
    return view;
}

- (void)clickBackgroundButton {
    
    //隐藏设置界面
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0.0f;
    }];
    [self.delegate hideSettingView];
}

- (void)clickSettingView {
    
    
}

- (void)updateValue:(id)slider {

    CGFloat light = self.lightSlider.value ;
    //设置屏幕的亮度
    [self.delegate setScreenLight:light];
}

- (void)clickLessButton {
    
    //字体变小
    [self.delegate lessFont];
}

- (void)clickAddButton {
    
    //字体变大
    [self.delegate addFont];
}

- (void)changeItem:(NSInteger)selectedIndex {
    
   //改变翻页方式
    [self.delegate changePageMethod:selectedIndex-1];
}

- (void)clickColorButton:(id)sender {
    
    NSInteger index = ((UIButton *)sender).tag - kBackgroundColorTag;
    //设置背景色
    [self.delegate changeBackgroundColor:index];
}

@end
