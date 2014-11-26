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

@property (nonatomic, strong) BookClassifyView *bookClassifyView;
@property (nonatomic, assign) OpenBookClassifyStyle style;

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
    
    NSArray *bookClassiyArray = [[DBInterfaceFactory classifyDBInterface] getAllClassify];
    
    self.bookClassifyView = [[BookClassifyView alloc] initWithFrame:self.view.bounds classifyArray:bookClassiyArray];
    self.bookClassifyView.delegate = self;
    [self.view addSubview:self.bookClassifyView];
}

#pragma mark
#pragma mark - BookClassifyViewDelegate

- (void)enterBookRack:(BookClassify *)bookClassify {
    
    [self close];
    if (self.style == OpenBookClassifySelectStyle) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEnterBookRackNotify object:bookClassify];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectWhichClassifyNotify object:bookClassify];
    }
}

#pragma mark - BarItemAction

- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
