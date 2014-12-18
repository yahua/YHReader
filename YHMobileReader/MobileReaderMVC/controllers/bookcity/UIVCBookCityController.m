//
//  UIVCBookCityController.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookCityController.h"
#import "BookCityNet.h"
#import "BookCityTopCell.h"
#import "APLParseOperation.h"

@interface UIVCBookCityController () <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

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
    [self.view addSubview:self.tableView];
    
    //初始化数据
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNetBooks:)
                                                 name:kAddNetBookNotificationName object:nil];
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
    id cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[BookCityTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];

    }
    
    NetBook *netBook = [self.netBookList objectAtIndex:indexPath.row];
    [cell reloadData:netBook];
    
    return cell;
}

#pragma mark - Private

- (void)initData {
    
    self.parseQueue = [NSOperationQueue new];
    self.operation = [BookCityNet getBookTopInfoWithSuccess:^(NSData *data) {
        APLParseOperation *parseOperation = [[APLParseOperation alloc] initWithData:data];
        [self.parseQueue addOperation:parseOperation];
    } failuer:^(NSString *msg) {
        
    }];
}

- (void)addNetBooks:(NSNotification *)notif {
    
    assert([NSThread isMainThread]);
    [self addNetBooksToList:[[notif userInfo] valueForKey:kNetBookResultsKey]];
}

- (void)addNetBooksToList:(NSArray *)netBooks {
    
    NSInteger startingRow = [self.netBookList count];
    NSInteger netBookCount = [netBooks count];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:netBookCount];
    
    for (NSInteger row = startingRow; row < (startingRow + netBookCount); row++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [indexPaths addObject:indexPath];
    }
    
    [self.netBookList addObjectsFromArray:netBooks];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
