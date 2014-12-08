//
//  UIVCBookCityController.m
//  YHMobileReader
//
//  Created by wangshiwen on 14/12/8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookCityController.h"
#import "YhFtpRequestManager.h"
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_AppContentHeight)];
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
    NSString *dateStr = [fileModel.fileDate description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", fileSizeStr, dateStr];
    
    return cell;
}

#pragma mark - Private

- (void)initData {
    
    self.operation = [[YhFtpRequestManager shareInstance] get:@"text/" success:^(NSString *msg, id data) {
        self.operation = nil;
        self.itemBookArray = [YHFtpLogic parserFileModelWithData:data];
        [self.tableView reloadData];
    } failuer:^(NSString *msg) {
        NSLog(@"%@", msg);
    }];
}

@end
