//
//  UIVCBookClassify.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-20.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookRack.h"
#import "BookClassifyView.h"
#import "BookRackView.h"
#import "BookRackHeaderView.h"
#import "DBInterfaceFactory.h"
#import "UIVCReadBook.h"

#define kAllBookClassifyID 10000

#define kBookClassifyWidth  (kUIScreen_Width - 60)
#define kSlideLegth  (kBookClassifyWidth/3)


@interface UIVCBookRack () <
BookClassifyViewDelegate,
BookRackViewDelegate,
BookViewDataSource,
BookRackHeaderViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, assign) BookClassifyView *bookClassifyView;
@property (nonatomic, assign) BookRackView *bookRackView;
@property (nonatomic, assign) BookRackHeaderView *bookRackHeaderView;
@property (nonatomic, retain) NSMutableArray *booksArray;
@property (nonatomic, assign) BOOL isShowBookRack;
@property (nonatomic, assign) NSInteger currentBookRackID;
/**
 当前书架
 */
@property (nonatomic, retain) BookClassify *currentBookClassify;
/**
 移动时选中的书籍
 */
@property (nonatomic, retain) Books *selectedBooks;

@property (nonatomic, assign) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation UIVCBookRack

- (void)dealloc {
    
    self.booksArray = nil;
    self.selectedBooks = nil;
    self.currentBookClassify = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //从阅读界面回来，刷新阅读进度
    if (self.selectedBooks) {
        
        [self.bookRackView reloadGridDate];
    }
}

- (void)viewDidLoad {
    
    NSArray *bookClassiyArray = [[DBInterfaceFactory classifyDBInterface] getAllClassify];
    
    self.bookClassifyView = [[[BookClassifyView alloc] initWithFrame:CGRectMake(-kBookClassifyWidth, 0, kBookClassifyWidth, self.view.height) classifyArray:bookClassiyArray] autorelease];
    self.bookClassifyView.delegate = self;
    [self.view addSubview:self.bookClassifyView];
    
    self.currentBookRackID = kAllBookClassifyID;
    self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getAllBooks]];
    self.bookRackView = [[[BookRackView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop + kUIScreen_TopBarHeight, kUIScreen_Width, kUIScreen_AppContentHeight)] autorelease];
    self.bookRackView.delegate = self;
    self.bookRackView.dataSource = self;
    [self.bookRackView reloadGridDate];
    [self.view addSubview:self.bookRackView];
    
    self.bookRackHeaderView = [[[BookRackHeaderView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop, kUIScreen_Width, kUIScreen_TopBarHeight)] autorelease];
    self.bookRackHeaderView.delegate = self;
    [self.bookRackHeaderView reloadHeaderTittle:@"我的书架"];
    [self.view addSubview:self.bookRackHeaderView];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureUpdated:)] autorelease];
    //self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    
    self.isShowBookRack = YES;
}

#pragma mark
#pragma mark - BookClassifyViewDelegate

- (void)enterBookRack:(BookClassify *)bookClassify {
    
    self.currentBookRackID = bookClassify.classifyID;
    self.currentBookClassify = nil;
    self.currentBookClassify = bookClassify;
    self.booksArray = nil;
    if (self.currentBookRackID == kAllBookClassifyID) {
        
         self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getAllBooks]];
    } else {
        
        self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getBooks:self.currentBookRackID]];
    }
    
    //刷新书架界面
    [self.bookRackView reloadGridDate];
    
    [self.bookRackHeaderView reloadHeaderTittle:bookClassify.classifyName];
    
    //隐藏分类界面
    [self viewAnimation:1];
}

- (void)selectWhichClassify:(BookClassify *)bookClassify {
    
    //返回书架界面
    [self viewAnimation:1];
    
    if (self.currentBookRackID != kAllBookClassifyID) {
        
        //BookRackView移除动画
        NSInteger index = [self.booksArray indexOfObject:self.selectedBooks];
        [self.bookRackView removeCellIndex:index];
        
        //数组移除
        [self.booksArray removeObject:self.selectedBooks];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //改变书籍bookRackID
        [[DBInterfaceFactory bookDBInterface] setBookRack:bookClassify.classifyID forBookID:self.selectedBooks.booksID];
        //新书籍为书架的最后一个位置
        NSArray *bookArray = [[DBInterfaceFactory bookDBInterface] getBooks:bookClassify.classifyID];
        [[DBInterfaceFactory bookDBInterface] setBookInRackPos:[bookArray count] withBookID:self.selectedBooks.booksID];
        
        [self.bookClassifyView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //刷新书架
            [self.bookRackView reloadGridDate];
        });
    });
}

#pragma mark
#pragma mark - BookViewDataSource

- (NSInteger)numberOfBook {
    
    return [self.booksArray count];
}

- (NSString *)bookName:(NSInteger)index {
    
    Books *books = [self.booksArray objectAtIndex:index];
    return books.booksName;
}

- (NSString *)bookPicName:(NSInteger)index {
    
    Books *books = [self.booksArray objectAtIndex:index];
    return books.booksPicName;
}

- (CGFloat)bookProgress:(NSInteger)index {
    
    Books *books = [self.booksArray objectAtIndex:index];
    return books.booksProgress;
}

#pragma mark
#pragma mark - BookRackViewDelegate

- (void)bookDidClick:(NSInteger)index {
    
    //进入阅读界面
    self.selectedBooks = [self.booksArray objectAtIndex:index];
    
    UIVCReadBook *controll = [[[UIVCReadBook alloc] initWithBookInfo:self.selectedBooks] autorelease];
    [self.navigationController pushViewController:controll animated:YES];
}

- (void)bookDidDelete:(NSInteger)index {
    
    //删除图书
    Books *books = [self.booksArray objectAtIndex:index];
    //数据库中删除
    [[DBInterfaceFactory bookDBInterface] deleteBook:books.booksID];
    //数据删除（先数据库后数组，要不然books为nil）
    [self.booksArray removeObject:books];
}

- (void)bookSortDidEnd {
    
    
}

- (void)bookDidMoveFromIndex:(NSInteger)fromIndex
                     toIndex:(NSInteger)toIndex {
    
    [self.booksArray exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

- (void)bookMoveToClassify:(NSInteger)index {
    
    self.selectedBooks = [self.booksArray objectAtIndex:index];
    //打开分类界面
    [self viewAnimation:0];
    self.bookClassifyView.isMoveToClassifyStyle = YES;
}


#pragma mark
#pragma mark - BookRackHeaderViewDelegate

- (void)clickEditButton {
    
    if (self.bookRackView.isInSortMode) {  //结束编辑模式
        
        [self.bookRackView stopSort];
        
        if (self.currentBookRackID != kAllBookClassifyID) {  //全部书架中暂不提供记录书籍位置
            
            //书籍在书架中的位置保存进数据库
            [[DBInterfaceFactory bookDBInterface] saveBooksWithRack:self.currentBookRackID withBooksArray:self.booksArray];
        }
    } else {  //进入编辑模式
        
        [self.bookRackView startSort];
    }
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.tapGestureRecognizer) {
        
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if (self.bookClassifyView.left == 0 && point.x >= kUIScreen_Width - 60) {
            
            return YES;
        } else if (self.bookRackView.left == 0 && point.x <= 25) {
            
            return YES;
        } else {
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 
#pragma mark - Action
//pan滑动处理函数
- (void)panGestureUpdated:(UIPanGestureRecognizer *)panGesture {
    
    //[self setScrollEnabled:YES];
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translatedPoint = [panGesture translationInView:self.view];
    
        if (self.isShowBookRack) {
            
            if (translatedPoint.x > kSlideLegth) {
                
                //滑出分类view
                [self viewAnimation:0];
            } else {
                
                [self viewAnimation:1];
            }
        } else {
            
            if (-translatedPoint.x > kSlideLegth) {
                
                //滑出分类view
                [self viewAnimation:1];
            } else {
                
                [self viewAnimation:0];
            }
        }
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translatedPoint = [panGesture translationInView:self.view];
        CGPoint offset = translatedPoint;
        
        if (self.isShowBookRack) {
            
            if (offset.x > 0) {
                self.bookRackView.left = offset.x;
                self.bookRackHeaderView.left = offset.x;
                self.bookClassifyView.left = -kBookClassifyWidth + offset.x;
            }
            
            if (translatedPoint.x > kSlideLegth) {
                
                self.bookRackView.directionImageView.image = [UIImage imageNamed:@"箭头2.png"];
            }
        }else {
            
            if (offset.x < 0) {
                
                self.bookClassifyView.left = offset.x;
                self.bookRackView.left = kBookClassifyWidth + offset.x;
                self.bookRackHeaderView.left = self.bookRackView.left;
            }
            
            if (translatedPoint.x < -kSlideLegth) {
                
                self.bookRackView.directionImageView.image = [UIImage imageNamed:@"箭头1.png"];
            }
        }
    }
}

/**
 index:0表示显示分类动画；1表示显示书架动画
 */

- (void)viewAnimation:(NSInteger)index {
    
    if (index == 0) {
        
        self.isShowBookRack = NO;
        self.bookClassifyView.isMoveToClassifyStyle = NO;
        self.bookRackView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.bookClassifyView.left = 0;
            self.bookRackView.left = kBookClassifyWidth;
            self.bookRackHeaderView.left = self.bookRackView.left;
        } completion:^(BOOL finished) {
            
            
        }];
    } else {
        
        self.isShowBookRack = YES;
        self.bookClassifyView.isMoveToClassifyStyle = NO;
        self.bookRackView.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.bookClassifyView.left = -kBookClassifyWidth;
            self.bookRackView.left = 0;
            self.bookRackHeaderView.left = self.bookRackView.left;
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

- (void)handleTap {
    
    if (self.bookRackView.left == 0) {
        
        [self viewAnimation:0];
        self.bookRackView.directionImageView.image = [UIImage imageNamed:@"箭头2.png"];
    } else {
        
        [self viewAnimation:1];
        self.bookRackView.directionImageView.image = [UIImage imageNamed:@"箭头1.png"];
    }
    
}

@end
