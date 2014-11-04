//
//  BookRackHeaderView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-2.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookRackHeaderViewDelegate

- (void)clickEditButton;

@end

@interface BookRackHeaderView : UIView

- (void)reloadHeaderTittle:(NSString *)tittle;

@property (nonatomic, assign) id<BookRackHeaderViewDelegate> delegate;

@end
