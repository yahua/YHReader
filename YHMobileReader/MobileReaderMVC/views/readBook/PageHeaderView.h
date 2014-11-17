//
//  PageHeaderView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-9.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageHeaderViewDelegate

- (void)clickReturn;

- (void)clickCatelog;

- (void)clickDaynight:(BOOL)isNight;

- (void)clickMark;

@end

@interface PageHeaderView : UIView

@property (nonatomic, weak) id<PageHeaderViewDelegate> delegate;

- (void)clickDaynightButton;

@end
