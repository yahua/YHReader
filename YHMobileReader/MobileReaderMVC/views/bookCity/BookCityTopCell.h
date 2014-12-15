//
//  BookCityTopCell.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-15.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHFtpFileModel.h"

#define kBookCityTopCellHeight  43

@interface BookCityTopCell : UITableViewCell

- (void)reloadData:(YHFtpFileModel *)fileModel;

@end
