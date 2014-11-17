//
//  PageSettingView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-12.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageSettingViewDelegate

- (void)hideSettingView;

- (void)setScreenLight:(CGFloat)light;

- (void)lessFont;

- (void)addFont;

- (void)changePageMethod:(NSInteger)pageMethod;

- (void)changeBackgroundColor:(NSInteger)colorID;

@end

@interface PageSettingView : UIView

@property (nonatomic, weak) id<PageSettingViewDelegate> delegate;

@end
