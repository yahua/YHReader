//
//  bookClassifyCell.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookClassify.h"

@protocol BookClassifyCellDelegate

- (void)cancelTableViewEditing:(NSInteger)classifyID;

- (void)resetClassifyName:(BookClassify *)bookClassify;

@end

@interface BookClassifyCell : UITableViewCell

@property (nonatomic, weak) id<BookClassifyCellDelegate> delegate;

- (void)initDate:(BookClassify *)bookClassify;

- (void)showNameTextField:(BOOL)isShow;

- (void)showAndBeginEditNameTextField;

- (void)closeKeyboard;

@end
