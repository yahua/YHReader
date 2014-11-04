//
//  BlockCreateUIDefine.m
//  nineclub
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

#import "BlockCreateUIDefine.h"


UILabel *(^block_createLabel)(UIColor *color,
                              CGRect frame,
                              CGFloat fontSize
                              ) = ^(UIColor *color,
                                    CGRect frame,
                                    CGFloat fontSize
                                    ) {
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    label.frame = frame;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
};

UIImageView *(^block_createImageView)(CGRect frame,
                                      NSString *imageName
                                      ) = ^(CGRect frame,
                                            NSString *imageName
                                            ) {
    
    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.frame = frame;
    
    return imageView;
};

UIButton *(^block_createButton)(CGRect frame,
                                NSString *imageName,
                                id delegate,
                                SEL selector
                                ) = ^(CGRect frame,
                                      NSString *imageName,
                                      id delegate,
                                      SEL selector
                                      ) {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName]
                      forState:UIControlStateNormal];
    button.frame = frame;
    [button addTarget:delegate
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
};

UIImageView *(^block_createLineImageView)(CGRect frame,
                                          UIColor *color,
                                          const CGFloat lengths[],
                                          size_t count
                                          ) = ^(CGRect frame,
                                                UIColor *color,
                                                const CGFloat lengths[],
                                                size_t count
                                                ) {
    
    UIImageView *lineView = [[[UIImageView alloc]initWithFrame:frame] autorelease];
    
    UIGraphicsBeginImageContext(lineView.frame.size);   //开始画线
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineDash(context, 0, lengths,count);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,lineView.frame.size.width , 0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    
    lineView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return lineView;
};

