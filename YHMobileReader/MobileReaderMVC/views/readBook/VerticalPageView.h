//
//  SimulationPageView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-9.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerticalPageViewDelegate

- (void)verticalPageViewScroll;

@end

@interface VerticalPageView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, weak) id<VerticalPageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withBookName:(NSString *)name;

- (CGFloat)getBooksProgress;

- (void)resetTextViewProperty;

@end
