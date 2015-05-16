//
//  UIVCBookCityController.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookCityController.h"
#import "BookCityTopCell.h"
#import "BookCityNet.h"
#import "DownloadBookManager.h"

#import "MBProgressHUD.h"
#import "ProgressHUD.h"

@interface UIVCBookCityController () <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) YHFtpRequestOperation *operation;
@property (nonatomic, strong) NSMutableArray *netBookList;
@property (nonatomic, strong) NSOperationQueue *parseQueue;

@end

@implementation UIVCBookCityController

- (void)dealloc
{
    if (self.operation) {
        [self.operation cancel];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"排行榜";
        self.netBookList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_ContentViewHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    //初始化数据
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
//    [BookCityNet test:^(NSArray *array) {
//        self.netBookList = [NSMutableArray arrayWithArray:array];
//        [self.tableView reloadData];
//    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.netBookList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kBookCityTopCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellString = @"kCellString";
    BookCityTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[BookCityTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];

    }
    NetBook *netBook = [self.netBookList objectAtIndex:indexPath.row];
    [cell reloadData:netBook];
    cell.userInteractionEnabled = netBook.isLocal?NO:YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NetBook *netBook = [self.netBookList objectAtIndex:indexPath.row];
    [self downLoadBookWithName:netBook indexPath:indexPath];
}

#pragma mark - Private

- (void)initData {
    
    //self.parseQueue = [NSOperationQueue new];
    self.operation = [BookCityNet getBookTopInfoWithSuccess:^(NSArray *array) {
        self.netBookList = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    } failuer:^(NSString *msg) {
        
    }];
}

- (void)downLoadBookWithName:(NetBook *)netBook indexPath:(NSIndexPath *)indexPath {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DownloadBookManager shareInstance] addDownloadBookTaskL:netBook.bookName bookImageUrl:netBook.bookImageName resultBlock:^(BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        NetBook *netBook = [self.netBookList objectAtIndex:indexPath.row];
        netBook.isLocal = YES;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            if (isSuccess) {
                [ProgressHUD showSuccess:@"下载成功！"];
            }else {
                [ProgressHUD showError:@"下载失败！"];
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}




@end
