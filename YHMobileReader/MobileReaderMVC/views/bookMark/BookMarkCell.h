//
//  BookMarkCell.h
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-14.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookMark.h"

@interface BookMarkCell : UITableViewCell

- (void)reloadDate:(BookMark *)bookMark;

@end
