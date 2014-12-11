//
//  UIVCBookCityController.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookCityController.h"
#import "BookCityNet.h"
#import "YHFtpFileModel.h"
#import "YHFtpLogic.h"

@interface UIVCBookCityController () <
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemBookArray;
@property (nonatomic, strong) YHFtpRequestOperation *operation;

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
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemBookArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellString = @"kCellString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];
    }
    YHFtpFileModel *fileModel = [self.itemBookArray objectAtIndex:indexPath.row];
    cell.textLabel.text = fileModel.fileName;
    
    NSString *fileSizeStr = [YHFtpLogic stringForFileSize:fileModel.fileSize];
    cell.detailTextLabel.text = fileSizeStr;
    
    return cell;
}

#pragma mark - Private

- (void)initData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.operation = [BookCityNet getBookTopWithSuccess:^(NSArray *array) {
            self.itemBookArray = array;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } failuer:^(NSString *msg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", msg);
            });
        }];
    });
}

@end
