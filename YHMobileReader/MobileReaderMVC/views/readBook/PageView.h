//
//  PageView.h
//  PageDemo
//
//  Created by 4DTECH on 13-4-12.
//  Copyright (c) 2013年 4DTECH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PageViewDelegate <NSObject>

-(void) didFinishMove;

@end

@interface PageView : UIView

@property (nonatomic, assign) UILabel *textLabel;

@property(nonatomic,assign) id<PageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withBookName:(NSString *)name;

- (void)move:(float)x animation:(BOOL)animation;

- (void)move:(float)x;

- (void)reloadText:(NSString *)text withProgress:(NSString *)progress;

- (void)resetFrame;

- (void)resetTextLabelProperty;

@end


