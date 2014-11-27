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
@property (nonatomic, strong) UIBarButtonItem *moveBarItem;
@property (nonatomic, strong) UIBarButtonItem *deleteBarItem;

@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, assign) NSInteger currentBookRackID;

@property (nonatomic, strong) NSMutableDictionary *selectBooksDic;
/**
 当前书架
 */
@property (nonatomic, strong) BookClassify *currentBookClassify;

@property (nonatomic, assign) BOOL isEditing;


@end

@implementation UIVCBookRack

- (void)dealloc {
    
    //移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {

        [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
        self.title = @"我的书架";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"精选" style:UIBarButtonItemStylePlain target:self action:@selector(classifyClick)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
        
        self.selectBooksDic = [NSMutableDictionary dictionary];
        
        //notify
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBookRack:) name:kEnterBookRackNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectWhichClassify:) name:kSelectWhichClassifyNotify object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //从阅读界面回来，刷新阅读进度
    //改为通知吧
//    if (self.selectedBooks) {
//        
//        [self.bookRackView reloadGridDate];
//    }
}

- (void)viewDidLoad {
    
    self.currentBookRackID = kAllBookClassifyID;
    self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getAllBooks]];
    self.bookRackView = [[BookRackView alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_AppContentHeight)];
    self.bookRackView.delegate = self;
    self.bookRackView.dataSource = self;
    [self.bookRackView reloadGridDate];
    [self.view addSubview:self.bookRackView];
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark
#pragma mark - NSNotification

- (void)enterBookRack:(NSNotification *)notification {
    
    BookClassify *bookClassify = (BookClassify *)notification.object;
    
    self.currentBookRackID = bookClassify.classifyID;
    self.currentBookClassify = nil;
    self.currentBookClassify = bookClassify;
    [self.booksArray removeAllObjects];
    if (self.currentBookRackID == kAllBookClassifyID) {
        
         self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getAllBooks]];
    } else {
        
        self.booksArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookDBInterface] getBooks:self.currentBookRackID]];
    }
    
    //刷新书架界面
    [self.bookRackView reloadGridDate];
    
    [self setBookRackName:bookClassify.classifyName];
}

- (void)selectWhichClassify:(NSNotification *)notification {
    
    BookClassify *bookClassify = (BookClassify *)notification.object;
    self.currentBookRackID = bookClassify.classifyID;
    if (self.currentBookRackID != kAllBookClassifyID) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray *bookArray = [[DBInterfaceFactory bookDBInterface] getBooks:bookClassify.classifyID];
            NSInteger total = [bookArray count];
            NSInteger index = 0;
            for (NSString *key in self.selectBooksDic.allKeys) {
                
                Books *books = [self.selectBooksDic objectForKey:key];
                //改变书籍bookRackID
                [[DBInterfaceFactory bookDBInterface] setBookRack:bookClassify.classifyID forBookID:books.booksID];
                //新书籍为书架的最后一个位置
                [[DBInterfaceFactory bookDBInterface] setBookInRackPos:total+index withBookID:books.booksID];
                
                index++;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //重新进入书架
                [self enterBookRack:notification];
            });
            [self.selectBooksDic removeAllObjects];
            [self reloadLeftBarItemState];
        });
    }
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
    
    if (self.isEditing) {
        Books *books = [self.booksArray objectAtIndex:index];
        NSString *key = [NSString stringWithFormat:@"%d", books.booksID];
        if ([self.selectBooksDic objectForKey:key]) {
            [self.selectBooksDic removeObjectForKey:key];
        }else {
            [self.selectBooksDic setObject:books forKey:key];
        }
        [self reloadLeftBarItemState];
    }else {
        //进入阅读界面
        UIVCReadBook *controll = [[UIVCReadBook alloc] initWithBookInfo:[self.booksArray objectAtIndex:index]];
        [self.navigationController pushViewController:controll animated:YES];
    }
}

- (void)bookDidMoveFromIndex:(NSInteger)fromIndex
                     toIndex:(NSInteger)toIndex {
    
    [self.booksArray exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

#pragma mark - BarItemAction

- (void)classifyClick {
    
    NSLog(@"classifyClick");
    UIVCBookClassify *vc = [[UIVCBookClassify alloc] initWithStyle:OpenBookClassifySelectStyle];
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
        
        UIBarButtonItem *classifyItem = [[UIBarButtonItem alloc] initWithTitle:@"精选" style:UIBarButtonItemStylePlain target:self action:@selector(classifyClick)];
        self.navigationItem.leftBarButtonItems = @[classifyItem];
    }else {  //进入编辑模式
        
        [self.bookRackView startSort];
        self.navigationItem.rightBarButtonItem.title = @"完成";
        
        self.moveBarItem.enabled = NO;
        self.deleteBarItem.enabled = NO;
        self.navigationItem.leftBarButtonItems = @[self.moveBarItem, self.deleteBarItem];
    }
    NSLog(@"editClick");
}

- (void)moveClick {
    
    UIVCBookClassify *vc = [[UIVCBookClassify alloc] initWithStyle:OpenBookClassifyMoveStyle];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)deleteClick {
    
    for (NSString *key in self.selectBooksDic.allKeys) {
        
        Books *books = [self.selectBooksDic objectForKey:key];
        NSInteger index = [self.booksArray indexOfObject:books];
        [self.bookRackView removeCellIndex:index];
    }
    
    for (NSString *key in self.selectBooksDic.allKeys) {
        
        Books *books = [self.selectBooksDic objectForKey:key];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //数据库中删除
            [[DBInterfaceFactory bookDBInterface] deleteBook:books.booksID];
            //数据删除（先数据库后数组，要不然books为nil）
            [self.booksArray removeObject:books];
        });
    }
    [self.selectBooksDic removeAllObjects];
    [self reloadLeftBarItemState];
}

#pragma mark - Private

- (UIBarButtonItem *)moveBarItem {
    
    if (!_moveBarItem) {
        _moveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"移动" style:UIBarButtonItemStylePlain target:self action:@selector(moveClick)];
    }
    return _moveBarItem;
}

- (UIBarButtonItem *)deleteBarItem {
    
    if (!_deleteBarItem) {
        _deleteBarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick)];
    }
    return _deleteBarItem;
}

- (void)reloadLeftBarItemState {
    
    if ([self.selectBooksDic count]>0) {
        self.moveBarItem.enabled = YES;
        self.deleteBarItem.enabled = YES;
        self.deleteBarItem.tintColor = [UIColor redColor];
    }else {
        self.moveBarItem.enabled = NO;
        self.deleteBarItem.enabled = NO;
    }
}

- (void)setBookRackName:(NSString *)name {
    
    if ([name isEqualToString:@"全部"]) {
        
        name = @"我的书架";
    }
    self.title = name;
}

@end
