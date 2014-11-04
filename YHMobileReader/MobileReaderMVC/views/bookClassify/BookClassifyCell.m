//
//  bookClassifyCell.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookClassifyCell.h"
#import "BlockCreateUIDefine.h"
#import "AppColor.h"
#import "UIView+Size.h"
#import "UIColor+Hex.h"
#import "ClassifyLogic.h"

#define kRowHeight 50
#define kLimitCharNumber 8

@interface BookClassifyCell () <
UITextFieldDelegate
>

@property (nonatomic, assign) UITextField *nameTextField;
@property (nonatomic, retain) BookClassify *bookClassify;

@end

@implementation BookClassifyCell

- (void)dealloc
{
    self.bookClassify = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[[AppColor shareAppColor] _0xffffff_60]];
        [self initSubviews];
    }
    return self;
}

#pragma mark
#pragma mark -Public

- (void)initDate:(BookClassify *)bookClassify {
    
    self.bookClassify = bookClassify;
    
    self.textLabel.text = [NSString stringWithFormat:@"   %@", bookClassify.classifyName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%d", bookClassify.bookNum];
}

- (void)showNameTextField:(BOOL)isShow {
    
    self.nameTextField.hidden = !isShow;
}

- (void)showAndBeginEditNameTextField {
    
    self.nameTextField.hidden = NO;
    [self.nameTextField becomeFirstResponder];
}

#pragma mark
#pragma mark -UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.delegate cancelTableViewEditing:self.bookClassify.classifyID];
    self.nameTextField.text = self.bookClassify.classifyName;
    self.nameTextField.placeholder = @"最多八个字符";
    self.nameTextField.font = [UIFont systemFontOfSize:15];
    self.textLabel.alpha = 0;
    self.detailTextLabel.alpha = 0;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {   // return NO to not change text {
    
    // 按下 键盘的 完成 按钮 可以隐藏键盘
    if([string isEqualToString:@"\n"]) {
        [self closeKeyboard];
        return NO;
    }
    
    return YES;
}

#pragma mark
#pragma mark -Private

- (void)initSubviews {
    
    self.textLabel.textColor = [[AppColor shareAppColor] _0x473125];
    self.textLabel.font = [UIFont systemFontOfSize:20];

    self.detailTextLabel.textColor = [[AppColor shareAppColor] _0x473125];
    self.detailTextLabel.font = [UIFont systemFontOfSize:20];
    
    self.nameTextField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 260, kRowHeight)] autorelease];
    self.nameTextField.delegate = self;
    self.nameTextField.textColor = [[AppColor shareAppColor] _0x473125];
    self.nameTextField.font = [UIFont systemFontOfSize:20];
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.nameTextField];
    self.nameTextField.hidden = YES;
    
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, kRowHeight - 1, 260, 1)] autorelease];
    lineView.backgroundColor = [UIColor colorWithHex:0xc1c1c1];
    [self addSubview:lineView];
}

- (void)showNameLabel {
    
    self.nameTextField.hidden = YES;
    self.bookClassify.classifyName = self.nameTextField.text;
    self.nameTextField.text = @"";

    self.textLabel.alpha = 1.0;
    self.detailTextLabel.alpha = 1.0;
    
    [self.delegate resetClassifyName:self.bookClassify];
}

- (void)closeKeyboard {
    
    if ([ClassifyLogic getBlogTextlength:self.nameTextField.text] > 8) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的字符超限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    self.nameTextField.placeholder = @"";
    [self.nameTextField resignFirstResponder];
    [self showNameLabel];
}

@end
