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

@end

@interface BookClassifyView : UIView

@property (nonatomic, weak) id<BookClassifyViewDelegate> delegate;

- (void)reloadData:(NSArray *)bookClassifyArray;

- (void)setIsEdit:(BOOL)isEdit;

@end
