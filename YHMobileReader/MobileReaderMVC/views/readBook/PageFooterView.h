//
//  PageFooterView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageFooterViewDelegate

- (void)showSettingView;

- (void)changeProgress:(CGFloat)progress;

@end

@interface PageFooterView : UIView

@property (nonatomic, weak) id<PageFooterViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withProgress:(CGFloat)progress;

@end
