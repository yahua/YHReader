//
//  BookCityTopCell.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookCityTopCell.h"
#import "BlockCreateUIDefine.h"

@interface BookCityTopCell ()

@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *tittleLable;
@property (nonatomic, strong) UILabel *sizeLable;

@end

@implementation BookCityTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.bookImageView = block_createImageView(CGRectMake(15, 6.5, 30, 30), nil);
        self.tittleLable = block_createLabel([UIColor blackColor], CGRectMake(self.bookImageView.right+5, 5, 200, 30), 17);
        self.sizeLable = block_createLabel([UIColor blackColor], CGRectMake(self.bookImageView.right+5, 0, 200, 20), 10);
        
        [self addSubview:self.bookImageView];
        [self addSubview:self.tittleLable];
        [self addSubview:self.sizeLable];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    [self.tittleLable resizeForHeight];
    [self.sizeLable resizeForHeight];
    
    self.tittleLable.top = 5;
    self.sizeLable.bottom = kBookCityTopCellHeight - 5;
}

#pragma mark - Public

- (void)reloadData:(YHFtpFileModel *)fileModel {
    
    self.tittleLable.text = fileModel.fileName;
    self.sizeLable.text = fileModel.fileSizeStr;
    [self.bookImageView setImageUrl:@"111"];
}

@end
