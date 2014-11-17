//
//  BookMarkCell.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-14.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookMarkCell.h"
#import "BlockCreateUIDefine.h"

@interface BookMarkCell ()

@property (nonatomic, strong) UILabel *decLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BookMarkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.decLabel = block_createLabel([UIColor blackColor], CGRectMake(14, 10, kUIScreen_Width - 28, 41), 13);
        self.decLabel.numberOfLines = 3;
        [self addSubview:self.decLabel];
        
        self.progressLabel = block_createLabel([UIColor blackColor], CGRectMake(14, self.decLabel.bottom+5, 100, 10), 10);
        [self addSubview:self.progressLabel];
        
        self.timeLabel = block_createLabel([UIColor blackColor], CGRectMake(0, self.progressLabel.top, 200, 10), 10);
        self.timeLabel.right = self.width - 14;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(14, 75, kUIScreen_Width - 28, 1)];
        lineView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
        [self addSubview:lineView];
    }
    return self;
}

- (void)reloadDate:(BookMark *)bookMark {
    
    self.decLabel.text = bookMark.bookMarkDes;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%@", bookMark.bookProgress*100, @"%"];
    self.timeLabel.text = bookMark.bookMarkDate;
}

@end
