//
//  BookRackHeaderView.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-2.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookRackHeaderView.h"
#import "BlockCreateUIDefine.h"

#define kImageViewTag  1000
#define kLabelTag  1001
#define kLabelWidth   192

@interface BookRackHeaderView ()

@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation BookRackHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.editButton.right = kUIScreen_Width - 6;
    self.editButton.width = 72;
}

- (void)reloadHeaderTittle:(NSString *)tittle {
    
    if ([tittle isEqualToString:@"全部"]) {
        
        tittle = @"我的书架";
    }
    self.tittleLabel.text = tittle;

}

- (void)initSubViews {
    
    self.tittleLabel = block_createLabel([UIColor blackColor], CGRectMake(64, 0, kLabelWidth, self.height), 20);
    self.tittleLabel.textAlignment = NSTextAlignmentCenter;
    self.tittleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.tittleLabel];
    
    self.editButton = block_createButton(CGRectMake(0, 6, 72, 32), @"", self, @selector(editButtonClick));
    self.editButton.backgroundColor = [UIColor colorWithHex:0xaad0dc];
    self.editButton.left = kUIScreen_Width - 78;
    self.editButton.layer.cornerRadius = 4;
    [self addSubview:self.editButton];
    
    UIImageView *imageView = block_createImageView(CGRectMake(10, 9, 14, 14), @"bookrack_edit@2x.png");
    imageView.tag = kImageViewTag;
    [self.editButton addSubview:imageView];
    
    UILabel *label = block_createLabel([UIColor whiteColor], CGRectMake(imageView.right + 5, 8, 32, 16), 16);
    label.tag = kLabelTag;
    label.text = @"编辑";
    [self.editButton addSubview:label];
}

- (void)editButtonClick {
    
    self.editButton.selected = !self.editButton.selected;
    
    if (self.editButton.selected) {
        
        UIImageView *imageView = (UIImageView *)[self.editButton viewWithTag:kImageViewTag];
        imageView.hidden = YES;
        
        UILabel *label = (UILabel *)[self.editButton viewWithTag:kLabelTag];
        label.text = @"完成";
        label.centerX = self.editButton.width/2;
    } else {
        
        UIImageView *imageView = (UIImageView *)[self.editButton viewWithTag:kImageViewTag];
        imageView.hidden = NO;
        
        UILabel *label = (UILabel *)[self.editButton viewWithTag:kLabelTag];
        label.text = @"编辑";
        label.left = imageView.right + 5;
    }
    
    [self.delegate clickEditButton];
}

@end
