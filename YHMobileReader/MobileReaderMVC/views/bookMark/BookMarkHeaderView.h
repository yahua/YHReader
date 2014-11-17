//
//  BookMarkHeaderView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-14.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookMarkHeaderViewDelegate

- (void)clickReturnButton;

@end

@interface BookMarkHeaderView : UIView

@property (nonatomic, strong) UILabel *bookNameLabel;

@property (nonatomic, weak) id<BookMarkHeaderViewDelegate> delegate;

@end
