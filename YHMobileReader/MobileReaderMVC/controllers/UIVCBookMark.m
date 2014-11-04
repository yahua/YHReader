//
//  UIVCBookMark.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-14.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookMark.h"
#import "BookMarkCell.h"
#import "Books.h"
#import "BookMarkHeaderView.h"
#import "DBInterfaceFactory.h"

@interface UIVCBookMark () <
UITableViewDataSource,
UITableViewDelegate,
BookMarkHeaderViewDelegate>

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, assign) BookMarkHeaderView *bookMarkHeaderView;
@property (nonatomic, retain) NSMutableArray *bookMarkArray;

@property (nonatomic, assign) NSInteger bookID;
@property (nonatomic, copy) NSString *bookName;

@end

@implementation UIVCBookMark

- (void)dealloc
{
    self.bookMarkArray = nil;
    self.bookName = nil;
    [super dealloc];
}

- (id)initWithBookID:(NSInteger)bookID withBookName:(NSString *)bookName
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.bookID = bookID;
        self.bookName = bookName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.bookMarkArray = [NSMutableArray arrayWithArray:[[DBInterfaceFactory bookMarkDBInterface] getBookMark:self.bookID]];
    
    self.bookMarkHeaderView = [[BookMarkHeaderView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop, kUIScreen_Width, kUIScreen_TopBarHeight)];
    self.bookMarkHeaderView.delegate = self;
    self.bookMarkHeaderView.bookNameLabel.text = self.bookName;
    [self.view addSubview:self.bookMarkHeaderView];
    self.navigationItem.leftBarButtonItem.title = self.bookName;
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop+kUIScreen_TopBarHeight, kUIScreen_Width, kUIScreen_AppContentHeight) style:UITableViewStylePlain] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark BookMarkHeaderViewDelegate

- (void)clickReturnButton {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.bookMarkArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellWithIdentifier = @"BookMarkCell";
    //BookClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    //if (cell == nil) {
    BookMarkCell *cell = [[[BookMarkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //}
    
    NSInteger row = indexPath.row;
    BookMark *bookMark = [self.bookMarkArray objectAtIndex:row];
    [cell reloadDate:bookMark];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //进入阅读界面
    BookMark *bookMark = [self.bookMarkArray objectAtIndex:indexPath.row];
    [[DBInterfaceFactory bookDBInterface] setBookProgress:bookMark.bookProgress forBookID:bookMark.bookID];
    [self.navigationController popViewControllerAnimated:YES];
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//方法类型：系统方法
//编   写：
//方法功能：删除指定数据
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        //从数据库中删除
        BookMark *bookMark = [self.bookMarkArray objectAtIndex:indexPath.row];
        [[DBInterfaceFactory bookMarkDBInterface] deleteBookMark:bookMark.bookMarkID forBookID:bookMark.bookID];
        
        //将数组中的数据删除
        [self.bookMarkArray removeObjectAtIndex:indexPath.row];
        
        //将当前cell删除
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
