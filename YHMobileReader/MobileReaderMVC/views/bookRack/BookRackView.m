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

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *sortingPanGesture;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) BookView *sortCell;

@property (nonatomic, assign) BOOL canSortCell;

//提示：长按可移动书籍到书架
@property (nonatomic, strong) UILabel *tipsLabel;

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
        self.scrollView.height = self.height - 22;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.backgroundColor = [UIColor clearColor];
        self.tipsLabel.text = @"长按书籍可进行分类";
        self.tipsLabel.font = [UIFont systemFontOfSize:12];
        self.tipsLabel.textColor = [UIColor blackColor];
        self.tipsLabel.shadowColor = [UIColor whiteColor];
        self.tipsLabel.shadowOffset = CGSizeMake(1, 1);
        self.tipsLabel.frame = CGRectMake(10, 0, 200, 12);
        self.tipsLabel.bottom = self.height - 5;
        [self addSubview:self.tipsLabel];
        
        self.directionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.directionImageView.centerY = self.height/2 - 40;
        self.directionImageView.image = [UIImage imageNamed:@"箭头1.png"];
        [self addSubview:self.directionImageView];
    
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
    
    self.tipsLabel.text = @"拖动书籍可进行排序";
}

- (void)stopSort {
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    
    for (NSInteger index = 0; index < cityCount; index++) {
        
        BookView *cell = [self subCellForIndex:index];
        
        [cell stopEditing];
    }
    
    self.isInSortMode = NO;
    self.tipsLabel.text = @"长按书籍可进行分类";
}

- (void)removeCellIndex:(NSInteger)index {
    
    BookView *bookView = [self subCellForIndex:index];
    [bookView removeFromSuperview];
    
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
    
    // 在编辑模式下，不接收用户的长按事件
    if (gestureRecognizer == self.longPressGesture &&
        self.isInSortMode) {
        
        return NO;
    }
    //不是编辑模式滑动事件不响应
    if (gestureRecognizer == self.sortingPanGesture &&
        !self.isInSortMode) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.longPressGesture) {
        return YES;
    }
    
    return NO;
}

#pragma mark
#pragma mark - BookViewDelegate

- (void)bookDidClick:(BookView *)bookView {
    
    [self.delegate bookDidClick:bookView.tag - kBaseTag];
}

- (void)bookDidDelete:(BookView *)bookView {
    
    [bookView removeFromSuperview];
    
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

                        [self.delegate bookDidDelete:bookView.tag - kBaseTag];
                        [self reloadGridDate];
  
                     }];

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
            
            self.sortCell.selectButton.selected = NO;
            
            [self relayoutItemsAnimate];
            
            [self.delegate bookSortDidEnd];
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

- (void)longPressGestureUpdated:(UILongPressGestureRecognizer *)longPressGesture {
    
    
    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            NSLog(@"long end");
            
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            
            // 判断用户触摸的位置是否是在item的contentframe中，
            // 如果是的话，设置sortCell，如果不是的话则不启动开始排序
            // 设置sortCell处于选中的状态
            
            NSLog(@"long begin");
            
            CGPoint location = [longPressGesture locationInView:self.scrollView];
            
            self.sortCell = [self locationCellContentByPoint:location];
            
            // 用户长按的地方是一个cell的话，开始启动排序的功能
            if (self.sortCell) {
                
                //移动到分类
                [self.delegate bookMoveToClassify:self.sortCell.tag - kBaseTag];
            }
            
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
    
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureUpdated:)];
    self.longPressGesture.numberOfTouchesRequired = 1;
    self.longPressGesture.minimumPressDuration = 1;
    self.longPressGesture.delegate = self;
    self.longPressGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:self.longPressGesture];
    
}

- (BookView *)locationCellContentByPoint:(CGPoint)point {
    
    BookView *sortCell = NULL;
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    for (NSInteger index = 0; index < cityCount; index++) {
        
        CGRect itemFrame = [self getBookViewFrame:index];
        
        if (CGRectContainsPoint(itemFrame, point)) {
            
            BookView *cell = [self subCellForIndex:index];
            sortCell = cell;
            sortCell.selectButton.selected = YES;
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
    
    
    
    
    BookView *sortCell = NULL;
    
    NSInteger cityCount = [self.dataSource numberOfBook];
    for (NSInteger index = 0; index < cityCount; index++) {
        
        CGRect itemFrame = [self getBookViewFrame:index];
        
        if (CGRectContainsPoint(itemFrame, point)) {
            
            BookView *cell = [self subCellForIndex:index];
            sortCell = cell;
            sortCell.selectButton.selected = YES;
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
