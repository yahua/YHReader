//
//  BookRackView.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-25.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookRackView.h"
#import "BookView.h"

#define kBaseTag       1000
#define kScrollerAddSize 147

@interface BookRackView () <
BookViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *sortingPanGesture;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BookView *sortCell;

@property (nonatomic, assign) BOOL canSortCell;

/**
 最大的ScrollerContentOffset
 */
@property (nonatomic, assign) CGFloat maxScrollerContentOffset;

@end

@implementation BookRackView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:0xdceaf0];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
    
        [self setupGesture];
    }
    return self;
}

#pragma mark
#pragma mark - Public

- (void)reloadGridDate {
    
    for(UIView *view in self.scrollView.subviews) {
        
        [view removeFromSuperview];
    }
    
    NSInteger count = [self.dataSource numberOfBook];
    if (!count) {
        return;
    }
    
    //重设 scrollerView 的 size和contentOffset 大小
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.frame.size.height);
    self.maxScrollerContentOffset = 0;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    NSInteger k = (count - 1)/3;
    if ((k+1) * kScrollerAddSize >= self.scrollView.frame.size.height) {
        
        self.maxScrollerContentOffset = (k+1) * kScrollerAddSize;
        
        self.scrollView.contentSize = CGSizeMake(kUIScreen_Width, self.maxScrollerContentOffset);
        
    }

    //创建BookView
    for (NSInteger index=0; index<count; index++) {
        
        BookView *bookView = [self createBookViewForIndex:index];
        bookView.delegate = self;
        if (self.isInSortMode) {
            [bookView startEditing];
        }
        [self.scrollView addSubview:bookView];
        
        [self reloadGridCellAtIndex:index];
    }

}

- (void)reloadGridCellAtIndex:(NSInteger)index {
    
    BookView *cell = [self subCellForIndex:index];
    
    NSString *picName = [self.dataSource bookPicName:index];
    [cell.selectButton setImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
    
    cell.bookNameLabel.text = [self.dataSource bookName:index];
    cell.bookProgressLabel.text = [NSString stringWithFormat:@"已读%.2f%@", [self.dataSource bookProgress:index] * 100, @"%"];
}

- (void)startSort {
    
    self.canSortCell = YES;
    self.isInSortMode = YES;
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    
    for (NSInteger index = 0; index < cityCount; index++) {
        
        BookView *cell = [self subCellForIndex:index];
        
        [cell startEditing];
    }
}

- (void)stopSort {
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    
    for (NSInteger index = 0; index < cityCount; index++) {
        
        BookView *cell = [self subCellForIndex:index];
        
        [cell stopEditing];
    }
    
    self.isInSortMode = NO;
}

- (void)removeCellIndex:(NSInteger)index {
    
    BookView *bookView = [self subCellForIndex:index];
    [bookView deleteSelf];
    
    // 将tag大于gridCell.tag的子cell的tag减1，然后再根据新的tag计算新的frame
    // 进行重新排列
    
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:0
                        options:kDefaultAnimationOptions
                     animations:^{
                         
                         NSInteger bookNumber = [self.dataSource numberOfBook];
                         NSInteger startIndex = bookView.tag-kBaseTag+1;
                         for (NSInteger index = startIndex; index < bookNumber; index++) {
                             
                             BookView *cell = [self subCellForIndex:index];
                             
                             cell.tag = cell.tag - 1;
                             
                             cell.frame = [self getBookViewFrame:index - 1];
                         }
                     }
     
                     completion:^(BOOL finished){
                         
                         [self reloadGridDate];
                     }];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //不是编辑模式滑动事件不响应
    if (gestureRecognizer == self.sortingPanGesture &&
        !self.isInSortMode) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark
#pragma mark - BookViewDelegate

- (void)bookDidClick:(BookView *)bookView {
    
    [self.delegate bookDidClick:bookView.tag - kBaseTag];
}

#pragma mark -
#pragma mark Private Gesture

- (void)sortingPanGestureUpdated:(UIPanGestureRecognizer *)panGesture {
    
    // 如果不是处于排序编辑的模式这里不进行调用
    if (!self.isInSortMode) {
        return;
    }
    
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            NSLog(@"sort end");
            
            // 这里都会执行到
            // 在用户的手指触摸离开屏幕的时候，这里会被调用到
            // 在这个地方将重新排列好的顺序写入到数据库，并通知MainWeather进行更新.
            //
            self.canSortCell = NO;
            
            [self relayoutItemsAnimate];
            
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"sort begin");
            
            CGPoint location = [panGesture locationInView:self.scrollView];
            
            //取得当前的bookview
            self.sortCell = [self locationCellContentByPoint:location];
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // 如果是处于排序的状态，则将sortCell的位置移动到手指的位置，
            // 如果手指的sortCell的中点触及到了其他cell的边缘，则进行位置替换
            
            // 如果sortCell不存在的话，根据当前触摸的位置，定位出cell.
            if (!self.canSortCell) {
                return;
            }
            
            if (!self.sortCell) {
                return;
            }
            
            CGPoint translation = [panGesture translationInView:self.scrollView];
            CGPoint offset = translation;
            
            
            [self.sortCell shakeStatus:NO];
            self.sortCell.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
            [self.scrollView bringSubviewToFront:self.sortCell];
            
            CGPoint location = [panGesture locationInView:self.scrollView];
            [self changeViewPositionByPoint:location];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark
#pragma mark - Private

- (BookView *)createBookViewForIndex:(NSInteger)index {
    
    BookView *bookView = [[BookView alloc] initWithFrame:[self getBookViewFrame:index]];
    bookView.tag = kBaseTag + index;
    
    return bookView;
}

- (BookView *)subCellForIndex:(NSInteger)index {
    
    return (BookView *)[self viewWithTag:kBaseTag + index];
}

- (void)setupGesture {
    
    self.sortingPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sortingPanGestureUpdated:)];
    self.sortingPanGesture.delegate = self;
    [self.scrollView addGestureRecognizer:self.sortingPanGesture];
    
}

- (BookView *)locationCellContentByPoint:(CGPoint)point {
    
    BookView *sortCell = NULL;
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    for (NSInteger index = 0; index < cityCount; index++) {
        
        CGRect itemFrame = [self getBookViewFrame:index];
        
        if (CGRectContainsPoint(itemFrame, point)) {
            
            BookView *cell = [self subCellForIndex:index];
            sortCell = cell;
            break;
        }
    }
    
    return sortCell;
}

- (void)changeViewPositionByPoint:(CGPoint)location {
    
    BookView *targetCell = [self locationCellByPoint:location];
    
    if (targetCell && self.sortCell && self.sortCell != targetCell) {
        
        NSInteger sourceCellIndex = self.sortCell.tag - kBaseTag;
        NSInteger targetCellIndex = targetCell.tag - kBaseTag;
        
        if (targetCellIndex > sourceCellIndex) {
            
            for (NSInteger index = sourceCellIndex+1; index <= targetCellIndex; index++) {
                
                BookView *cell = [self subCellForIndex:index];
                NSInteger fromIndex = cell.tag;
                NSInteger toIndex = cell.tag - 1;
                cell.tag = toIndex;
                [self.delegate bookDidMoveFromIndex:fromIndex-kBaseTag
                                            toIndex:toIndex-kBaseTag];
                [self sendSubviewToBack:cell];
            }
        } else {
            
            for (NSInteger index = sourceCellIndex - 1; index >= targetCellIndex ; index--) {
                
                BookView *cell = [self subCellForIndex:index];
                NSInteger fromIndex = cell.tag;
                NSInteger toIndex = cell.tag + 1;
                cell.tag = toIndex;
                [self.delegate bookDidMoveFromIndex:fromIndex-kBaseTag
                                            toIndex:toIndex-kBaseTag];
                [self sendSubviewToBack:cell];
            }
        }
        self.sortCell.tag = targetCellIndex + kBaseTag;
        
        [self relayoutItemsAnimateWithoutSort];
        
    }
}

- (BookView *)locationCellByPoint:(CGPoint)point {
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:kDefaultAnimationOptions
                     animations:^{
                         
                         if (self.sortCell.frame.origin.y < self.scrollView.contentOffset.y) {
                             CGFloat newY =  self.scrollView.contentOffset.y - kScrollerAddSize;
                             if (newY < 0) {
                                 newY = 0;
                             }
                             self.scrollView.contentOffset = CGPointMake(0, newY);
                             
                             CGRect newFrame = self.sortCell.frame;
                             newFrame.origin.y = self.scrollView.contentOffset.y + 10;
                             self.sortCell.frame = newFrame;
                             
                         }
                         
                         if ((self.sortCell.frame.origin.y + self.sortCell.frame.size.height) > self.scrollView.contentOffset.y + self.scrollView.frame.size.height) {
                             CGFloat newY =  self.scrollView.contentOffset.y + kScrollerAddSize;
                             if (newY >= self.maxScrollerContentOffset) {
                                 newY = self.maxScrollerContentOffset;
                             }
                             self.scrollView.contentOffset = CGPointMake(0, newY);
                             
                             CGRect newFrame = self.sortCell.frame;
                             newFrame.origin.y = self.scrollView.contentOffset.y + self.scrollView.frame.size.height - kScrollerAddSize - 30;
                             self.sortCell.frame = newFrame;
                             
                         }
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
    
    BookView *sortCell = nil;
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    for (NSInteger index = 0; index < cityCount; index++) {
        
        CGRect itemFrame = [self getBookViewFrame:index];
        
        if (CGRectContainsPoint(itemFrame, point)) {
            
            sortCell = [self subCellForIndex:index];
            break;
        }
    }
    
    return sortCell;
}

- (void)relayoutItemsAnimateWithoutSort {
    
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:0
                        options:kDefaultAnimationOptions
                     animations:^{
                         
                         NSInteger cityNumber = [self.dataSource numberOfBook];
                         
                         for (NSInteger index = 0; index < cityNumber; index++) {
                             
                             BookView *cell = [self subCellForIndex:index];
                             if (cell != self.sortCell) {
                                 
                                 cell.frame = [self getBookViewFrame:index];
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void)relayoutItemsAnimate {
    
    BookView *sortCell = self.sortCell;
    
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:0
                        options:0
                     animations:^{
                         
                         NSInteger cityNumber = [self.dataSource numberOfBook];
                         
                         for (NSInteger index = 0; index < cityNumber; index++) {
                             
                             BookView *cell = [self subCellForIndex:index];
                             
                             NSLog(@"tag:%d", cell.tag);
                             
                             cell.transform = CGAffineTransformMakeTranslation(0, 0);
                             cell.frame = [self getBookViewFrame:index];
                             
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         // 解决长按后开始对选中的排序，后停止震动的情况
                         
                         if (self.isInSortMode) {
                             
                             [sortCell shakeStatus:YES];
                         }
                         
                         
                         self.sortCell = nil;
                         
                         self.canSortCell = YES;
                     }];
}

//获取bookview的frame
- (CGRect)getBookViewFrame:(NSInteger)index {
    
    NSInteger row = (index/3);
    NSInteger col = (index%3);
    
    CGFloat x = col*kBookViewWidth;
    CGFloat y = row*kBookViewHeight;
    
    x += col * kBookViewLeftPadding2 + kBookViewLeftPadding1;
    y += (row+1) * kBookViewTopPadding;
    
    return CGRectMake(x,
                      y,
                      kBookViewWidth,
                      kBookViewHeight);
}

@end
