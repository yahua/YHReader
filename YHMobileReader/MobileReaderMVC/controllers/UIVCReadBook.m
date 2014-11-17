//
//  DemoViewController.m
//  PageDemo
//
//  Created by 4DTECH on 13-4-12.
//  Copyright (c) 2013年 4DTECH. All rights reserved.
//

#import "UIVCReadBook.h"
#import "ReadInfoManager.h"
#import "VerticalPageView.h"
#import "PageView.h"
#import "PageHeaderView.h"
#import "PageFooterView.h"
#import "PageSettingView.h"
#import "DBInterfaceFactory.h"
#import "UIVCBookMark.h"
#import "BookMark.h"
#import "MBProgressHUD.h"

#define kPageCount   [ReadInfoManager shareReadInfoManager].maxNumCharacter
#define kPageFontSize  [ReadInfoManager shareReadInfoManager].fontSize
#define kMinMoveWidth  (kUIScreen_Width/5)

@interface UIVCReadBook () <
PageViewDelegate,
VerticalPageViewDelegate,
PageHeaderViewDelegate,
PageFooterViewDelegate,
PageSettingViewDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, copy)     NSString *textStr;
@property (nonatomic, strong)   Books *bookInfo;

@property (nonatomic, strong)   PageView *visitPage;
@property (nonatomic, strong)   PageView *prePage;
@property (nonatomic, strong)   PageView *nextPage;
@property (nonatomic, strong)   VerticalPageView *verticalPageView;
@property (nonatomic, strong)   PageHeaderView *pageHeaderView;
@property (nonatomic, strong)   PageFooterView *pageFooterView;
@property (nonatomic, strong)   PageSettingView *pageSettingView;
@property (nonatomic, strong)   UIScrollView *scrollview;

@property (nonatomic, strong)   MBProgressHUD *hud;

//点击手势 点击显示顶部和底部界面
@property (nonatomic, strong)   UITapGestureRecognizer *tapGestureRecognizer;

//滑动手势
@property (nonatomic, strong)   UIPanGestureRecognizer *panGestureRecognizer;

//是否显示设顶部和底部界面
@property (nonatomic, assign)   BOOL isShowSetting;


@end

@implementation UIVCReadBook


- (id)initWithBookInfo:(Books *)bookInfo {
    
    self = [super init];
    if (self) {
        
        self.bookInfo = bookInfo;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.bookInfo.booksProgress = [[DBInterfaceFactory bookDBInterface] getBookProgress:self.bookInfo.booksID];
   
    self.hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
    self.hud.userInteractionEnabled = NO;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud show:YES];
    [self.view addSubview:self.hud];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //仿真翻页方式
    [self showPageMethod];
    [self.hud removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    //读取阅读界面信息
    [ReadInfoManager shareReadInfoManager];
    self.view.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    currentIndex = 0;
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_Height)];
    //self.scrollview.backgroundColor = [UIColor redColor];
    [self.scrollview setDelegate:self];
    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setShowsHorizontalScrollIndicator:NO];
	[self.scrollview setShowsVerticalScrollIndicator:NO];
    self.scrollview.userInteractionEnabled = NO;
    [self.view addSubview:self.scrollview];

    self.verticalPageView = [[VerticalPageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_Height) withBookName:self.bookInfo.booksName];
    self.verticalPageView.hidden = YES;
    self.verticalPageView.delegate = self;
    [self.view addSubview:self.verticalPageView];
    
    //顶部
    self.pageHeaderView = [[PageHeaderView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop, kUIScreen_Width, kUIScreen_TopBarHeight)];
    self.pageHeaderView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.pageHeaderView.bottom = 0;
    self.pageHeaderView.delegate = self;
    [self.view addSubview:self.pageHeaderView];
    
    //底部
    self.pageFooterView = [[PageFooterView alloc] initWithFrame:CGRectMake(0, self.view.height - kUIScreen_BottomBarHeight, kUIScreen_Width, kUIScreen_BottomBarHeight) withProgress:self.bookInfo.booksProgress];
    self.pageFooterView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.pageFooterView.top = self.view.height;
    self.pageFooterView.delegate =self;
    [self.view addSubview:self.pageFooterView];
    
    //添加手势
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.delegate = self;
    self.panGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    //设置界面
    self.pageSettingView = [[PageSettingView alloc] initWithFrame:self.view.bounds];
    self.pageSettingView.alpha = 0.0f;
    self.pageSettingView.delegate = self;
    [self.view addSubview:self.pageSettingView];
    
    //读取文本
    self.textStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.bookInfo.booksPath ofType:@"txt" ]encoding:NSUTF8StringEncoding error:nil];
    
    //[self setNeedsStatusBarAppearanceUpdate];
//    [UIView animateWithDuration:0.5 animations:^{
//        [self setNeedsStatusBarAppearanceUpdate];
//    }];
    
    
}

#pragma mark
#pragma mark - PageViewDelegate

- (void)didFinishMove {
    
    [self indexChange:nextPageIndex];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark
#pragma mark - VerticalPageViewDelegate

- (void)verticalPageViewScroll {
    
    if (self.isShowSetting) {
        
        [self handleTap];
        
    }
}

#pragma mark
#pragma mark - PageHeaderViewDelegate

- (void)clickReturn {
    
    switch ([ReadInfoManager shareReadInfoManager].pageMethod) {

        case YhReadHorizontal:
        case YhReadSimulation:
        {
            [[DBInterfaceFactory bookDBInterface] setBookProgress:self.bookInfo.booksProgress forBookID:self.bookInfo.booksID];
        }
            break;
            
        case YhreadVertical:
            self.bookInfo.booksProgress = [self.verticalPageView getBooksProgress];
            [[DBInterfaceFactory bookDBInterface] setBookProgress:self.bookInfo.booksProgress forBookID:self.bookInfo.booksID];
            break;
            
        default:
            break;
    }
    
    [[ReadInfoManager shareReadInfoManager] updateReadInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCatelog {
    
    [self handleTap];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    switch ([ReadInfoManager shareReadInfoManager].pageMethod) {
            
        case YhReadHorizontal:
        case YhReadSimulation:
        {
            [[DBInterfaceFactory bookDBInterface] setBookProgress:self.bookInfo.booksProgress forBookID:self.bookInfo.booksID];
        }
            break;
            
        case YhreadVertical:
            self.bookInfo.booksProgress = [self.verticalPageView getBooksProgress];
            [[DBInterfaceFactory bookDBInterface] setBookProgress:self.bookInfo.booksProgress forBookID:self.bookInfo.booksID];
            break;
            
        default:
            break;
    }
    
    UIVCBookMark *bookMarkControll = [[UIVCBookMark alloc] initWithBookID:self.bookInfo.booksID withBookName:self.bookInfo.booksName];
    [self.navigationController pushViewController:bookMarkControll animated:YES];
}

- (void)clickDaynight:(BOOL)isNight {
    
    if (isNight) {
        
        [[ReadInfoManager shareReadInfoManager] changeBackgroundColor:3];
    } else {
        [[ReadInfoManager shareReadInfoManager] restoreLastColor];
    }
    
    [self.prePage resetTextLabelProperty];
    [self.visitPage resetTextLabelProperty];
    [self.nextPage resetTextLabelProperty];
    [self.verticalPageView resetTextViewProperty];
    self.pageHeaderView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.pageFooterView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
}

- (void)clickMark {
    
    NSArray *bookMarkArray = [[DBInterfaceFactory bookMarkDBInterface] getBookMark:self.bookInfo.booksID];
    for (BookMark *bookMark in bookMarkArray) {
        
        if ([bookMark.bookMarkDes isEqualToString:[self.visitPage.textLabel.text  substringToIndex:200]]) {
            
            MBProgressHUD *markHud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
            markHud.userInteractionEnabled = NO;
            markHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            markHud.mode = MBProgressHUDModeCustomView;
            markHud.labelText = @"书签已存在";
            markHud.removeFromSuperViewOnHide = YES;
            [markHud hide:YES afterDelay:1];
            [markHud show:YES];
            [self.view addSubview:markHud];
            [self handleTap];
            return;
        }
    }
    
    BookMark *bookMark = [[BookMark alloc] init];
    bookMark.bookID = self.bookInfo.booksID;
    bookMark.bookMarkID = [bookMarkArray count];
    bookMark.bookMarkDes = [self.visitPage.textLabel.text  substringToIndex:200];
    bookMark.bookProgress = [self getCurrentProgress];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YY/MM/dd hh:mm:ss"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    bookMark.bookMarkDate = locationString;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DBInterfaceFactory bookMarkDBInterface] addBookMark:bookMark];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
            hud.userInteractionEnabled = NO;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"添加成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
            [hud show:YES];
            [self.view addSubview:hud];
        });
        
    });

    
    [self handleTap];
}

#pragma mark
#pragma mark - PageFooterViewDelegate

- (void)showSettingView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.pageSettingView.alpha = 1.0;
    }];
}

- (void)changeProgress:(CGFloat)progress {
    
    self.bookInfo.booksProgress = progress;
    
    self.visitPage.textLabel.text = @"";
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    [hud show:YES];
    [self.view addSubview:hud];
    [self performSelector:@selector(showPageMethod) withObject:nil afterDelay:1.0f];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DBInterfaceFactory bookDBInterface] setBookProgress:self.bookInfo.booksProgress forBookID:self.bookInfo.booksID];
    });
}

#pragma mark
#pragma mark - PageSettingViewDelegate

- (void)hideSettingView {
    
    //隐藏
    [self handleTap];
}

- (void)setScreenLight:(CGFloat)light {
    
    [[ReadInfoManager shareReadInfoManager] setScreenLight:light];
    [[UIScreen mainScreen] setBrightness:light/100];
}

- (void)lessFont {
    
    [[ReadInfoManager shareReadInfoManager] lessFont];
    
    if ([ReadInfoManager shareReadInfoManager].fontSize == 10) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
        hud.userInteractionEnabled = NO;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"字体已最小";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [hud show:YES];
        [self.view addSubview:hud];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    [hud show:YES];
    [self.view addSubview:hud];
    [self performSelector:@selector(changeFontSize) withObject:nil afterDelay:1.0f];
}

- (void)addFont {
    
    if ([ReadInfoManager shareReadInfoManager].fontSize == 20) {
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
        hud.userInteractionEnabled = NO;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"字体已最大";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        [hud show:YES];
        [self.view addSubview:hud];
        return;
    }
    
    [[ReadInfoManager shareReadInfoManager] addFont];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:(UIWindow *)self.view];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    [hud show:YES];
    [self.view addSubview:hud];
    [self performSelector:@selector(changeFontSize) withObject:nil afterDelay:1.0f];
}

- (void)changePageMethod:(NSInteger)pageMethod {
    
    [[ReadInfoManager shareReadInfoManager] changePageMethod:pageMethod];
    //刷新界面
    currentIndex = 0;
    nextPageIndex = 0;
    [self showPageMethod];
}

- (void)changeBackgroundColor:(NSInteger)colorID {
    
    if (colorID == 3) {  //相当于点击了月亮按钮
        
        [self.pageHeaderView clickDaynightButton];
    } else {
        
        [[ReadInfoManager shareReadInfoManager] changeBackgroundColor:colorID];
    }
    //刷新界面
    [self.prePage resetTextLabelProperty];
    [self.visitPage resetTextLabelProperty];
    [self.nextPage resetTextLabelProperty];
    [self.verticalPageView resetTextViewProperty];
    self.pageHeaderView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    self.pageFooterView.backgroundColor = [ReadInfoManager shareReadInfoManager].backgroundColor;
    //[self showPageMethod];
}

- (void)changeFontSize {
    
    //刷新界面
    [self.prePage resetTextLabelProperty];
    [self.visitPage resetTextLabelProperty];
    [self.nextPage resetTextLabelProperty];
    [self.verticalPageView resetTextViewProperty];
    currentIndex = 0;
    [self showPageMethod];
}

#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isShowSetting) {   //如果已经显示了顶部和底部
        
        [self handleTap];
    }
    
//    CGPoint scrollViewContentOffset = scrollView.contentOffset;
//    scrollViewContentOffset.y = 0;
//    scrollView.contentOffset = scrollViewContentOffset;
    
    CGPoint point = [scrollView.panGestureRecognizer velocityInView:self.scrollview];
    
    if (point.x > 0) {
        
        isRight = YES;
    }else if (point.x < 0) {
        
        isRight = NO;
    }
    if (self.bookInfo.booksProgress < 0.00001 && isRight) {
        scrollView.contentOffset = CGPointMake(kUIScreen_Width, 0);
        //提示第一页
    }
    
    if (self.bookInfo.booksProgress > 0.99999 && !isRight) {
        
        scrollView.contentOffset = CGPointMake(kUIScreen_Width, 0);
        //提示最后一页
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView contentOffset].x > self.scrollview.width) {
        
        PageView *view = self.prePage;
            self.prePage = self.visitPage;
            self.visitPage = self.nextPage;
            self.nextPage = view;
            
            [self.prePage setFrame:[self leftPageViewFrame]];
            [self.visitPage setFrame:[self centerPageViewFrame]];
            [self.nextPage setFrame:[self rightPageViewFrame]];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *str = [self getPageText:YhPageDown];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.nextPage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
            });
        });
        
    } else if ([scrollView contentOffset].x < self.scrollview.width) {
        // 将右边的移动到左边
        
            PageView *view = self.nextPage;
            self.nextPage = self.visitPage;
            self.visitPage = self.prePage;
            self.prePage = view;
            
            [self.prePage setFrame:[self leftPageViewFrame]];
            [self.visitPage setFrame:[self centerPageViewFrame]];
            [self.nextPage setFrame:[self rightPageViewFrame]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *str = [self getPageText:YHPageUp];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.prePage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
                });
            });
    }
    
    [self.scrollview scrollRectToVisible:[self centerPageViewFrame] animated:NO];
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    

    if (gestureRecognizer == self.panGestureRecognizer) {
        
        return YES;
    } else {
        
        if (self.pageSettingView.alpha > 0.0f) {
            
            return NO;
        }
        
        CGPoint point = [gestureRecognizer locationInView:self.view];
        if (self.isShowSetting) {
            
            if (point.y>64 && point.y<kUIScreen_Height - kUIScreen_BottomBarHeight) {
                
                return YES;
            }else {
                
                return NO;
            }
        } else {
            
            
            if (point.x >= 80 && point.x <= 240) {
                
                return YES;
            }else {
                
                return NO;
            }
        }
    }
}

#pragma mark
#pragma mark - Action

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    
    switch (panGesture.state) {
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            
            float x = [panGesture locationInView:self.view].x;
            
            if (!fromLeft && (tap||startX - x >kMinMoveWidth))
            {
                [self.view setUserInteractionEnabled:NO];
                self.nextPage.hidden = NO;
                nextPageIndex = currentIndex+1;
                [self.visitPage move:-self.view.frame.size.width animation:YES];
            }
            else if(!fromLeft && startX - x <=kMinMoveWidth)
            {
                [self.view setUserInteractionEnabled:NO];
                [self.visitPage move:self.view.frame.size.width animation:YES];
            }
            else
            {
                [self.view setUserInteractionEnabled:NO];
                self.prePage.hidden = NO;
                if (fromLeft && (tap||x-  startX >kMinMoveWidth))
                {
                    nextPageIndex = currentIndex-1;
                    [self.prePage move:self.view.frame.size.width animation:YES];
                }
                else if(fromLeft &&  x - startX<=kMinMoveWidth)
                {
                    [self.prePage move:-self.view.frame.size.width animation:YES];
                }
            }
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            if (self.isShowSetting) {
                [self handleTap];
            }
            float x = [panGesture locationInView:self.view].x;
            startX = x;
            fromLeft = x< self.view.frame.size.width /2;
            tap = YES;
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if(fromLeft && self.bookInfo.booksProgress < 0.000001)
                return;
            
            if (!fromLeft && self.bookInfo.booksProgress > 0.999999) {
                return;
            }
            
            float x = [panGesture locationInView:self.view].x;
            
            if (fromLeft) {
                
                self.prePage.hidden = NO;
                self.nextPage.hidden = YES;
                [self.prePage move:x];
                
            }
            else
            {
                self.prePage.hidden = YES;
                self.nextPage.hidden = NO;
                [self.visitPage move:x];
                
            }
            tap = NO;
            
            break;
        }
        default:
            break;

    }
}

- (void)handleTap {
    
    if (self.isShowSetting) { //隐藏
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.pageHeaderView.bottom = 0;
            self.pageFooterView.top = self.view.height;
            self.pageSettingView.alpha = 0.0f;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }];
    }else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.pageHeaderView.top = kUIScreen_AppTop;
            self.pageFooterView.bottom = self.view.height;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }];
    }
    
    self.isShowSetting = !self.isShowSetting;
}

#pragma mark
#pragma mark - Private

- (PageView *)createView {
    
    PageView *pageView = [[PageView alloc] initWithFrame:self.scrollview.bounds withBookName:self.bookInfo.booksName];
    pageView.hidden = YES;
    pageView.delegate = self;
    [self.scrollview addSubview:pageView];
    return pageView;
}

//显示翻页方式
- (void)showPageMethod {
    
    switch ([ReadInfoManager shareReadInfoManager].pageMethod) {
        case YhReadSimulation:
            [self showSimulationPage];
            break;
            
        case YhReadHorizontal:
            [self showHorizontalPage];
            break;
            
        case YhreadVertical:
            [self showVerticalPage];
            break;
            
        default:
            break;
    }
    
}

//仿真翻页
- (void)showSimulationPage {
    
    self.verticalPageView.hidden = YES;
    self.scrollview.userInteractionEnabled = NO;
    
    if (self.prePage) {
        [self.prePage removeFromSuperview];
    }
    if (self.visitPage) {
        [self.visitPage removeFromSuperview];
    }
    if (self.nextPage) {
        [self.nextPage removeFromSuperview];
    }
    
    //创建3个pageview
    self.nextPage = [self createView];
    self.visitPage = [self createView];
    self.prePage = [self createView];
    
    self.visitPage.hidden = NO;
    
    [self initPageText];
    
    self.panGestureRecognizer.enabled = YES;
}

//水平翻页
- (void)showHorizontalPage {
    
    self.panGestureRecognizer.enabled = NO;
    self.verticalPageView.hidden = YES;
    
    if (self.prePage) {
        [self.prePage removeFromSuperview];
    }
    if (self.visitPage) {
        [self.visitPage removeFromSuperview];
    }
    if (self.nextPage) {
        [self.nextPage removeFromSuperview];
    }
    
    //创建3个pageview
    self.nextPage = [self createView];
    self.visitPage = [self createView];
    self.prePage = [self createView];
    
    self.prePage.frame = [self leftPageViewFrame];
    self.visitPage.frame = [self centerPageViewFrame];
    self.nextPage.frame = [self rightPageViewFrame];
    
    self.prePage.hidden = NO;
    self.visitPage.hidden = NO;
    self.nextPage.hidden = NO;
    
    [self initPageText];
    
    self.scrollview.userInteractionEnabled = YES;
    self.scrollview.contentSize = CGSizeMake(3*kUIScreen_Width, kUIScreen_AppHeight);
    [self.scrollview scrollRectToVisible:[self centerPageViewFrame] animated:NO];
    [self.scrollview setBounces:NO];
}

//垂直翻页
- (void)showVerticalPage {
    
    self.panGestureRecognizer.enabled = NO;
    self.scrollview.userInteractionEnabled = NO;
    
    self.verticalPageView.hidden = NO;
    self.verticalPageView.textView.text = self.textStr;
    
    NSInteger hasNumStr = [self.textStr length] * self.bookInfo.booksProgress;
    [self.verticalPageView.textView scrollRangeToVisible:NSMakeRange(hasNumStr, 0)];
}

- (void)initPageText {
    
    if (self.bookInfo.booksProgress > 0.9999) {
        


        NSInteger totleLength = [self.textStr length];
            NSInteger startPos = totleLength - kPageCount;
        
            NSRange rang = NSMakeRange(startPos, kPageCount);
            NSString *str = [self.textStr substringWithRange:rang];
            
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
            NSInteger length = kPageCount;
            if (size.height > kHeight) {
                
                for (; length >= 0; length--) {
                    
                    startPos = totleLength - length;
                    
                    rang = NSMakeRange(startPos, length);
                    str = [self.textStr substringWithRange:rang];
                    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
                    if (size.height <= kHeight) {
                        length++;
                        break;
                    }
                }
            }
            
        [self.visitPage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", self.bookInfo.booksProgress * 100, @"%"]];
        return;
    }
    
    
    NSInteger startPos = self.bookInfo.booksProgress * [self.textStr length];
    NSRange rang = NSMakeRange (startPos, kPageCount);
    NSString *str = [self.textStr substringWithRange:rang];
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
    NSInteger length = kPageCount;
    if (size.height > kHeight) {
        
        for (; length >= 0; length--) {
            rang = NSMakeRange (startPos, length);
            str = [self.textStr substringWithRange:rang];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
            if (size.height <= kHeight) {
                
                break;
            }
        }
    }
    [self.visitPage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", self.bookInfo.booksProgress * 100, @"%"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *str = [self getPageText:YhPageDown];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.nextPage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *str = [self getPageText:YHPageUp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.prePage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
        });
    });
    
}

- (void)indexChange:(int)newIndex {
    
    if(currentIndex == newIndex) {
        
        return;
    }

        if (newIndex>currentIndex) {
            
                
            PageView *view = self.prePage;
            self.prePage = self.visitPage;
            self.visitPage = self.nextPage;
            self.nextPage = view;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *str = [self getPageText:YhPageDown];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.nextPage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
                });
            });
            
            //复原位置
            [self.nextPage resetFrame];
            
            [self.scrollview sendSubviewToBack:self.nextPage];
            [self.scrollview bringSubviewToFront:self.prePage];
            
        }else {
            
            PageView *view = self.nextPage;
            self.nextPage = self.visitPage;
            self.visitPage = self.prePage;
            self.prePage = view;
            
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *str = [self getPageText:YHPageUp];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.prePage reloadText:str withProgress:[NSString stringWithFormat:@"%.2f%@", [self getCurrentProgress] * 100, @"%"]];
                    });
                });
  
            [self.scrollview sendSubviewToBack:self.nextPage];
            [self.scrollview bringSubviewToFront:self.prePage];
            
        }
    currentIndex = newIndex;
}

- (NSString *)getPageText:(YHPageSytle)pageStlye {
    
    NSRange visitRange = [self.textStr rangeOfString:self.visitPage.textLabel.text];
    if (visitRange.length <= 0) {
        return @"";
    }
    
    if (pageStlye == YhPageDown || pageStlye == YhPageNone) {
        
        NSInteger startPos = visitRange.location + visitRange.length;
        
        NSRange rang = NSMakeRange (startPos, kPageCount);
        NSString *str = [self.textStr substringWithRange:rang];
        
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
        NSInteger length = kPageCount;
        if (size.height > kHeight) {
            
            for (; length >= 0; length--) {
                rang = NSMakeRange (startPos, length);
                str = [self.textStr substringWithRange:rang];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
                if (size.height <= kHeight) {
                    length++;
                    break;
                }
            }
        }
        
        return str;
    } else {
        
        NSInteger startPos = visitRange.location - kPageCount;
        if (startPos < 0) {
            startPos = 0;
        }
        NSRange rang = NSMakeRange(startPos, kPageCount);
        NSString *str = [self.textStr substringWithRange:rang];
        
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
        NSInteger length = kPageCount;
        if (size.height > kHeight) {
            
            for (; length >= 0; length--) {
                
                startPos = visitRange.location - length;
                if (startPos < 0) {
                    startPos = 0;
                }
                rang = NSMakeRange(startPos, length);
                str = [self.textStr substringWithRange:rang];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:kPageFontSize] constrainedToSize:CGSizeMake(kWidth, MAXFLOAT)];
                if (size.height <= kHeight) {
                    length++;
                    break;
                }
            }
        }
        
        return str;
    }
}

- (CGRect)leftPageViewFrame {
    
    return CGRectMake(0,
                      0,
                      kUIScreen_Width,
                      kUIScreen_Height);
}

- (CGRect)centerPageViewFrame {
    
    return CGRectMake(kUIScreen_Width,
                      0,
                      kUIScreen_Width,
                      kUIScreen_Height);
}

- (CGRect)rightPageViewFrame {
    
    return CGRectMake(kUIScreen_Width*2,
                      0,
                      kUIScreen_Width,
                      kUIScreen_Height);
}

- (CGFloat)getCurrentProgress {
    
    NSString *str = self.visitPage.textLabel.text;
    NSRange range = [self.textStr rangeOfString:str];
    if (range.length <= 0) {
        return 0.0f;
    }
    self.bookInfo.booksProgress = (CGFloat)range.location/[self.textStr length];
    return self.bookInfo.booksProgress;
}

@end
