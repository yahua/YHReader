//
//  BookView.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-24.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Books.h"

#define kBookViewWidth      81
#define kBookViewHeight     127
#define kBookViewLeftPadding1    24
#define kBookViewLeftPadding2    15
#define kBookViewTopPadding     20

static const CGFloat kDefaultAnimationDuration = 0.4;
static const UIViewAnimationOptions kDefaultAnimationOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;

@class BookView;

@protocol BookViewDelegate

- (void)bookDidClick:(BookView *)bookView;

- (void)bookDidDelete:(BookView *)bookView;

@end

@interface BookView : UIView

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *bookProgressLabel;

@property (nonatomic, weak) id<BookViewDelegate> delegate;

- (void)startEditing;

- (void)stopEditing;

- (void)shakeStatus:(BOOL)isShake;
@end
