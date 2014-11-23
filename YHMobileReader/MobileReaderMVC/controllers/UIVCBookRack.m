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
#import "UIVCBookClassify.h"

#define kAllBookClassifyID 10000

#define kBookClassifyWidth  (kUIScreen_Width - 60)
#define kSlideLegth  (kBookClassifyWidth/3)


@interface UIVCBookRack () <
BookRackViewDelegate,
BookViewDataSource>

@property (nonatomic, strong) BookRackView *bookRackView;
@property (nonatomic, strong) BookRackHeaderView *bookRackHeaderView;
@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, assign) NSInteger currentBookRackID;
/**
 当前书架
 */
@property (nonatomic, strong) BookClassify *currentBookClassify;

/**
 移动时选中的书籍
 */
@property (nonatomic, strong) Books *selectedBooks;


@property (nonatomic, assign) BOOL isEditing;

@end

@implementation UIVCBookRack

- (void)dealloc {
    
    //移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
        self.title = @"我的书架";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"精选" style:UIBarButtonItemStylePlain target:self action:@selector(classifyClick)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
        
        //notify
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBookRack:) name:kEnterBookRackNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectWhichClassify::) name:kSelectWhichClassifyNotify object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //从阅读界面回来，刷新阅读进度
    if (self.selectedBooks) {
        
        [self.bookRackView reloadGridDate];
    }
}

- (void)viewDidLoad {
    
    self.currentBookRackID = kAllBookClassifyID;
    self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getAllBooks]];
    self.bookRackView = [[BookRackView alloc] initWithFrame:CGRectMake(0, kUIScreen_TopBarHeight+kUIScreen_AppTop, kUIScreen_Width, kUIScreen_AppContentHeight)];
    self.bookRackView.delegate = self;
    self.bookRackView.dataSource = self;
    [self.bookRackView reloadGridDate];
    [self.view addSubview:self.bookRackView];
}

#pragma mark
#pragma mark - NSNotification

- (void)enterBookRack:(NSNotification *)notification {
    
    BookClassify *bookClassify = (BookClassify *)notification.object;
    
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
    
    self.title = bookClassify.classifyName;
}

- (void)selectWhichClassify:(NSNotification *)notification {
    
    BookClassify *bookClassify = (BookClassify *)notification.object;
    
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
        
        //[self.bookClassifyView reloadData];
        
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
    
    UIVCReadBook *controll = [[UIVCReadBook alloc] initWithBookInfo:self.selectedBooks];
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
    
    //self.bookClassifyView.isMoveToClassifyStyle = YES;
}


#pragma mark - BarItemAction

- (void)classifyClick {
    
    NSLog(@"classifyClick");
    UIVCBookClassify *vc = [[UIVCBookClassify alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)editClick {
    
    self.isEditing = !self.isEditing;
    if(!self.isEditing) {  //结束编辑模式
        
        [self.bookRackView stopSort];
        
        if (self.currentBookRackID != kAllBookClassifyID) {  //全部书架中暂不提供记录书籍位置
            
            //书籍在书架中的位置保存进数据库
            [[DBInterfaceFactory bookDBInterface] saveBooksWithRack:self.currentBookRackID withBooksArray:self.booksArray];
        }
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }else {  //进入编辑模式
        
        [self.bookRackView startSort];
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
    NSLog(@"editClick");
}

@end
