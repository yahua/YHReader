//
//  BookRackView.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-25.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookViewDataSource

- (NSInteger)numberOfBook;

- (NSString *)bookName:(NSInteger)index;

- (NSString *)bookPicName:(NSInteger)index;

- (CGFloat)bookProgress:(NSInteger)index;

@end

@protocol BookRackViewDelegate 

- (void)bookDidClick:(NSInteger)index;

- (void)bookDidDelete:(NSInteger)index;

- (void)bookSortDidEnd;

- (void)bookDidMoveFromIndex:(NSInteger)fromIndex
                     toIndex:(NSInteger)toIndex;

- (void)bookMoveToClassify:(NSInteger)index;

@end

@interface BookRackView : UIView

@property (nonatomic, weak) id<BookRackViewDelegate> delegate;
@property (nonatomic, weak) id<BookViewDataSource> dataSource;
@property (nonatomic, strong) UIImageView *directionImageView;
/**
 是否是在编辑模式
 */
@property (nonatomic, assign) BOOL isInSortMode;

/**
 更新书架
 */
- (void)reloadGridDate;

/**
 更新某一本书
 */
- (void)reloadGridCellAtIndex:(NSInteger)index;

/**
 开始排序
 */
- (void)startSort;

/**
 结束排序
 */
- (void)stopSort;

/**
 移除某个cell
 */
- (void)removeCellIndex:(NSInteger)index;

@end
