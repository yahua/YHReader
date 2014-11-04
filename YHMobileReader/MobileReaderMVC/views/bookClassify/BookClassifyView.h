//
//  bookClassifyView.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-20.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookClassify.h"

@protocol BookClassifyViewDelegate

- (void)enterBookRack:(BookClassify *)bookClassify;
- (void)selectWhichClassify:(BookClassify *)bookClassify;

@end

@interface BookClassifyView : UIView

- (id)initWithFrame:(CGRect)frame classifyArray:(NSArray *)bookClassifyArray;

@property (nonatomic, assign) id<BookClassifyViewDelegate> delegate;

/**
 NO:正常打开   YES：移动分类de打开
 */
@property (nonatomic, assign) BOOL isMoveToClassifyStyle;

- (void)reloadData;

@end
