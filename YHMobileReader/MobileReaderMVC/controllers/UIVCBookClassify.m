//
//  UIVCBookClassify.m
//  YHMobileReader
//
//  Created by 王时温 on 14-11-19.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "UIVCBookClassify.h"
#import "BookClassifyView.h"
#import "DBInterfaceFactory.h"

@interface UIVCBookClassify () <
BookClassifyViewDelegate>

@property (nonatomic, strong) BookClassifyView          *bookClassifyView;
@property (nonatomic, assign) OpenBookClassifyStyle     style;
@property (nonatomic, assign) BOOL                      *isEditing;

@end

@implementation UIVCBookClassify

- (id)initWithStyle:(OpenBookClassifyStyle)style;
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.style = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bookClassifyView = [[BookClassifyView alloc] initWithFrame:self.view.bounds];
    self.bookClassifyView.delegate = self;
    [self.view addSubview:self.bookClassifyView];
    
    [self initData];
}

#pragma mark - Public

- (void)presentModallyOn:(UIViewController *)controller animated:(BOOL)animated {
    
    UINavigationController *    navController;
    navController = [[UINavigationController alloc] initWithRootViewController:self];
    assert(navController != nil);
    
    self.navigationItem.title = @"精选集";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishClick)];
    [controller presentViewController:navController animated:YES completion:nil];
}

#pragma mark
#pragma mark - BookClassifyViewDelegate

- (void)enterBookRack:(BookClassify *)bookClassify {
    
    [self finishClick];
    if (self.style == OpenBookClassifySelectStyle) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEnterBookRackNotify object:bookClassify];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectWhichClassifyNotify object:bookClassify];
    }
}

#pragma mark - BarItemAction

- (void)editClick {
    
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        self.navigationItem.leftBarButtonItem.title = @"完成";
        self.navigationItem.rightBarButtonItem.title = @"";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.leftBarButtonItem.title = @"编辑";
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    [self.bookClassifyView setIsEdit:self.isEditing];
}

- (void)finishClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private 

- (void)initData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *bookClassiyArray = [[DBInterfaceFactory classifyDBInterface] getAllClassify];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bookClassifyView reloadData:bookClassiyArray];
        });
    });
}

@end
