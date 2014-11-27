//
//  UIVCBookClassify.h
//  YHMobileReader
//
//  Created by 王时温 on 14-11-19.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OpenBookClassifyStyle) {
    
    OpenBookClassifySelectStyle,        //选择目录
    OpenBookClassifyMoveStyle           //书籍移动目录
};

#define  kEnterBookRackNotify            @"EnterBookRackNotify"
#define  kSelectWhichClassifyNotify      @"SelectWhichClassifyNotify"

@interface UIVCBookClassify : UIViewController

- (id)initWithStyle:(OpenBookClassifyStyle)style;

@end
