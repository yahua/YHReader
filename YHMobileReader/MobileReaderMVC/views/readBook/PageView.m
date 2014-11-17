//
//  PageView.m
//  PageDemo
//
//  Created by 4DTECH on 13-4-12.
//  Copyright (c) 2013年 4DTECH. All rights reserved.
//

#import "PageView.h"
#import "ReadInfoManager.h"

@interface PageView ()

@property (nonatomic, strong) UIImageView *mirrorImageView;
@property (nonatomic, strong) UIView *parentViewMirrorImg;
@property (nonatomic, strong) UIView *parentViewForTxt;
@property (nonatomic, strong) CAGradientLayer *nShadow;

@property (nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation PageView


- (id)initWithFrame:(CGRect)frame withBookName:(NSString *)name;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initSubviews:name];
        [self resetTextLabelProperty];
    }
    return self;
}

#pragma mark -
#pragma mark Public

- (void)reloadText:(NSString *)text withProgress:(NSString *)progress; {

    self.textLabel.text = text;
    self.progressLabel.text = progress;
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hh:mm"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    self.timeLabel.text = locationString;
    //
    UIGraphicsBeginImageContext(self.parentViewForTxt.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 这里不用滤镜了 随便加点灰色吧
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0xcc /255.0 green:0xcc /255.0 blue:0xcc /255.0 alpha:0.2].CGColor);
    CGContextTranslateCTM(context, self.parentViewForTxt.width, 0);
    CGContextScaleCTM(context, -1, 1);
    
    [self.parentViewForTxt.layer renderInContext:context];
    CGContextFillRect(context, self.parentViewForTxt.bounds);
    
    self.mirrorImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CAGradientLayer *shadow = [[CAGradientLayer alloc] init];
    shadow.colors =[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0xee /255.0 green:0xee /255.0 blue:0xee /255.0 alpha:0.2].CGColor,(id)[UIColor colorWithRed:0x00 /255.0 green:0x00 /255.0 blue:0x00 /255.0 alpha:0.3].CGColor
                    ,nil];
    shadow.frame = CGRectMake(-5, 0, 5, self.frame.size.height);
    shadow.startPoint = CGPointMake(0, 0.5);
    shadow.endPoint = CGPointMake(1.0, 0.5);
    
    self.mirrorImageView.clipsToBounds = NO;
    [self.mirrorImageView.layer addSublayer:shadow];
}

- (void)move:(float)x
{
    
    self.nShadow.hidden = NO;
    self.parentViewMirrorImg.hidden = NO;
    
    CGRect rect = self.parentViewMirrorImg.frame;
    rect.origin.x = x;
    rect.size.width = self.frame.size.width - x;
    self.parentViewMirrorImg.frame = rect;
    
    rect = self.parentViewForTxt.frame;
    rect.size.width = x;
    rect.origin.x = self.frame.size.width - x;
    self.parentViewForTxt.frame = rect;
    
    rect = self.frame;
    rect.origin.x = -(self.frame.size.width - x);
    self.frame = rect;
}

- (void)move:(float)x animation:(BOOL)animation
{
    
    if (animation) {
        [UIView beginAnimations:@"ad" context:nil];
        [UIView setAnimationDidStopSelector:@selector(didFinishMove)];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    }
    
    CGRect rect = self.parentViewMirrorImg.frame;
    rect.origin.x = x;
    rect.size.width = self.frame.size.width - x;
    self.parentViewMirrorImg.frame = rect;
    
    rect = self.parentViewForTxt.frame;
    rect.size.width = x;
    rect.origin.x = self.frame.size.width - x;
    self.parentViewForTxt.frame = rect;
    
    rect = self.frame;
    rect.origin.x = -(self.frame.size.width - x);
    self.frame = rect;
    if(animation)
    {
        [UIView commitAnimations];
    }
}

- (void)resetFrame {
    
    self.left = 0;
    self.width = kUIScreen_Width;
    
    self.parentViewForTxt.frame = self.bounds;
    self.parentViewMirrorImg.frame = self.bounds;
    self.parentViewMirrorImg.hidden = YES;
}

- (void)resetTextLabelProperty {
    
    self.textLabel.font = [UIFont systemFontOfSize:[ReadInfoManager shareReadInfoManager].fontSize];
    self.textLabel.textColor = [ReadInfoManager shareReadInfoManager].fontColor;
    self.textLabel.numberOfLines = [ReadInfoManager shareReadInfoManager].rowNums;
    self.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.parentViewForTxt.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    
    self.progressLabel.textColor = [ReadInfoManager shareReadInfoManager].fontColor;
    self.bookNameLabel.textColor = [ReadInfoManager shareReadInfoManager].fontColor;
    self.timeLabel.textColor = [ReadInfoManager shareReadInfoManager].fontColor;
}

#pragma mark
#pragma mark - Action

- (void)didFinishMove
{
    self.nShadow.hidden = YES;
    [self.delegate didFinishMove];
}

#pragma mark -
#pragma mark Private

- (void)initSubviews:(NSString *)name {
    
    self.parentViewForTxt = [[UIView alloc] initWithFrame:self.bounds];
    self.parentViewForTxt.clipsToBounds = YES;
    [self addSubview:self.parentViewForTxt];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 36, self.parentViewForTxt.width - 30, self.parentViewForTxt.height - 86)];
    self.textLabel.text = @"";
    [self.parentViewForTxt addSubview:self.textLabel];
    
    
    self.parentViewMirrorImg = [[UIView alloc] initWithFrame:self.bounds];
    self.parentViewMirrorImg.clipsToBounds = YES;
    // self.clipsToBounds = NO;
    self.mirrorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.parentViewForTxt.width, self.parentViewForTxt.height)];
    [self.parentViewMirrorImg addSubview:self.mirrorImageView];
    [self addSubview:self.parentViewMirrorImg];
    self.parentViewMirrorImg.hidden = YES;
    
    //
    self.nShadow = [CAGradientLayer layer];
    self.nShadow.colors =[NSArray arrayWithObjects:(id)[UIColor colorWithRed:0xee /255.0 green:0xee /255.0 blue:0xee /255.0 alpha:0.1].CGColor,(id)[UIColor colorWithRed:0x00 /255.0 green:0x00 /255.0 blue:0x00 /255.0 alpha:0.2].CGColor,
                            (id)[UIColor colorWithRed:0xee /255.0 green:0xee /255.0 blue:0xee /255.0 alpha:0.1].CGColor
                            ,nil];
    self.nShadow.frame = CGRectMake(self.frame.size.width - self.frame.size.width /6 /2, 0, self.frame.size.width /6, self.frame.size.height);
    self.nShadow.startPoint = CGPointMake(0, 0.5);
    self.nShadow.endPoint = CGPointMake(1.0, 0.5);
    self.nShadow.hidden = YES;
    [self.layer addSublayer:self.nShadow];
    
    //底部进度
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    self.progressLabel.left = 15;
    self.progressLabel.bottom = self.parentViewForTxt.height - 15;;
    self.progressLabel.font = [UIFont systemFontOfSize:10];
    self.progressLabel.textColor = [UIColor colorWithHex:0x000000];
    [self.parentViewForTxt addSubview:self.progressLabel];
    
    //顶部书名和时间
    self.bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 10)];
    self.bookNameLabel.font = [UIFont systemFontOfSize:10];
    self.bookNameLabel.textColor = [UIColor colorWithHex:0x000000];
    self.bookNameLabel.text = name;
    [self.parentViewForTxt addSubview:self.bookNameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 10)];
    self.timeLabel.right = self.parentViewForTxt.width - 15;
    self.timeLabel.bottom = self.parentViewForTxt.height - 15;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    self.timeLabel.textColor = [UIColor colorWithHex:0x000000];
    [self.parentViewForTxt addSubview:self.timeLabel];
}

@end
