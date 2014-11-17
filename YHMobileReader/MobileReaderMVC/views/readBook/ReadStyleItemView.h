//
//  ReadStyleItemView.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-12.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadStyleItemViewDelegate

- (void)changeItem:(NSInteger)selectedIndex;

@end

@interface ReadStyleItemView : UIView

@property (nonatomic, weak) id<ReadStyleItemViewDelegate> delegate;

- (void)changeSelectedIndex:(NSInteger)index;

@end
