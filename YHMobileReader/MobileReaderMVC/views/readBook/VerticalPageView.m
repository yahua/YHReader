//
//  SimulationPageView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-9.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "VerticalPageView.h"
#import "ReadInfoManager.h"

@interface VerticalPageView () <
UITextViewDelegate>

@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation VerticalPageView


- (id)initWithFrame:(CGRect)frame withBookName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSubviews:name];
        [self reloadProgress];
        [self resetTextViewProperty];
    }
    return self;
}

- (void)initSubviews:(NSString *)name {
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, self.width-30, self.height - 60)];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.textView setShowsHorizontalScrollIndicator:NO];
    [self.textView setShowsVerticalScrollIndicator:NO];
    self.textView.editable= NO;
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    //底部进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.progressLabel.left = 15;
    self.progressLabel.bottom = self.height - 10;
    self.progressLabel.font = [UIFont systemFontOfSize:10];
    self.progressLabel.textColor = [UIColor colorWithHex:0x000000];
    [self addSubview:self.progressLabel];
    
    //顶部书名和时间
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 10)];
    self.bookNameLabel.font = [UIFont systemFontOfSize:10];
    self.bookNameLabel.textColor = [UIColor colorWithHex:0x000000];
    self.bookNameLabel.text = name;
    self.bookNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bookNameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.timeLabel.right = self.width - 15;
    self.timeLabel.bottom = self.height - 10;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor colorWithHex:0x000000];
    [self addSubview:self.timeLabel];
}

- (CGFloat)getBooksProgress {
    
    CGPoint point = self.textView.contentOffset;
    CGSize size = self.textView.contentSize;
    if (point.y < 0)
        point.y = 0;
    
    return (CGFloat)point.y/size.height;
}

- (void)reloadProgress {
    
    self.progressLabel.text = [NSString stringWithFormat:@"全书:%.2f%@", [self getBooksProgress]*100, @"%"];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hh:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    self.timeLabel.text = locationString;
}

- (void)resetTextViewProperty {
    
    self.textView.font = [UIFont systemFontOfSize:[ReadInfoManager shareReadInfoManager].fontSize];
    self.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.textView.textColor = [ReadInfoManager shareReadInfoManager].fontColor;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.delegate verticalPageViewScroll];
    [self reloadProgress];
}

@end
