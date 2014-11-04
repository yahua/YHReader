//
//  DemoViewController.h
//  PageDemo
//
//  Created by 4DTECH on 13-4-12.
//  Copyright (c) 2013年 4DTECH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Books.h"

typedef NS_ENUM(NSUInteger, YHPageSytle) {
    YhPageNone,
    YhPageDown,
    YHPageUp
};

typedef NS_ENUM(NSUInteger, YHReadStyle) {
    YhReadSimulation,
    YhReadHorizontal,
    YhreadVertical
};



@interface UIVCReadBook : UIViewController
{
    int currentIndex;
    BOOL fromLeft;
    BOOL tap;
    float startX;
    int nextPageIndex;
    
    BOOL isRight;
}

- (id)initWithBookInfo:(Books *)bookInfo;



@end
