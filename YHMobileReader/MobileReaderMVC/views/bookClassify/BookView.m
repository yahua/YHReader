//
//  BookView.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-24.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BookView.h"
#import "BlockCreateUIDefine.h"
#import "AppColor.h"
#import "UIView+Size.h"

@interface BookView ()

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) BOOL editing;

@end

@implementation BookView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //self.clipsToBounds = YES;
        [self initSubviews];
    }
    
    return self;
}

#pragma mark
#pragma mark - Pbulic

- (void)reloadDate:(Books *)books {
    
    [self.selectButton setBackgroundImage:[UIImage imageNamed:books.booksPicName]
                      forState:UIControlStateNormal];
    self.bookNameLabel.text = books.booksName;
    self.bookProgressLabel.text = [NSString stringWithFormat:@"已读%f%@", (books.booksProgress*100), @"%"];
}

- (void)startEditing {
    
    self.editing = YES;
    
    self.deleteButton.hidden = NO;
    [self shakeStatus:YES];
}

- (void)stopEditing {
    
    self.editing = NO;
    
    self.deleteButton.hidden = YES;
    [self shakeStatus:NO];
}

#pragma mark
#pragma mark - Private

- (void)initSubviews {
    
    self.selectButton = block_createButton(CGRectMake(0, 0, self.width, 97), nil, self, @selector(selectButtonClick:));
    self.selectButton.layer.borderColor = [UIColor colorWithHex:0x000000 alpha:0.3].CGColor;
    self.selectButton.layer.borderWidth = 1;
    [self addSubview:self.selectButton];
    
    self.bookNameLabel = block_createLabel([[AppColor shareAppColor] _0x473125], CGRectMake(0, self.selectButton.bottom + 3, 81, 15), 15);
    self.bookNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.bookNameLabel];
    
    
    self.bookProgressLabel = block_createLabel([[AppColor shareAppColor] _0x473125_60], CGRectMake(0, self.bookNameLabel.bottom + 2, 81, 10), 10);
    [self addSubview:self.bookProgressLabel];
    
    self.deleteButton = block_createButton(CGRectMake(0, 0, 30, 30), @"book_delete.png", self, @selector(deleteButtonClick:));
    self.deleteButton.hidden = YES;
    [self addSubview:self.deleteButton];
}

- (void)shakeStatus:(BOOL)isShake {
    
    if (isShake)
    {
        CGFloat rotation = 0.03;
        
        CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
        shake.duration = 0.13;
        shake.autoreverses = YES;
        shake.repeatCount  = MAXFLOAT;
        shake.removedOnCompletion = NO;
        shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
        shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
        
        [self.layer addAnimation:shake forKey:@"shakeAnimation"];
    }
    else
    {
        [self.layer removeAnimationForKey:@"shakeAnimation"];
    }
}

#pragma mark
#pragma mark - Action

- (void)selectButtonClick:(id)sender {
    
    [self.delegate bookDidClick:self];
}

- (void)deleteButtonClick:(id)sender {
    
    
    self.clipsToBounds = YES;
    
    [UIView animateWithDuration:kDefaultAnimationDuration
                          delay:0
                        options:kDefaultAnimationOptions
                     animations:^{
                         
                         CGAffineTransform newTransform =
                         CGAffineTransformScale(self.transform, 0.1, 0.1);
                         [self setTransform:newTransform];
                         
                         self.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
                     }
                     completion:^(BOOL finished){
                         
                         [self.delegate bookDidDelete:self];
                     }
     ];
}

@end
