//
//  BlockCreateUIDefine.h
//  common
//
//  Created by logiph on 4/13/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

extern UILabel *(^block_createLabel)(UIColor *color,
                                     CGRect frame,
                                     CGFloat fontSize
                                     );

extern UIImageView *(^block_createImageView)(CGRect frame,
                                             NSString *imageName
                                             );

extern UIButton *(^block_createButton)(CGRect frame,
                                       NSString *imageName,
                                       id delegate,
                                       SEL selector
                                       );

extern UIImageView *(^block_createLineImageView)(CGRect frame,
                                                 UIColor *color,
                                                 const CGFloat lengths[],
                                                 size_t count
                                                 );
