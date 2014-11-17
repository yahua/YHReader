//
//  ReadInfoManager.m
//  YHMobileReader
//
//  Created by wangshiwen on 14-4-8.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ReadInfoManager.h"
#import "DBInterfaceFactory.h"

@implementation ReadInfoManager

+ (ReadInfoManager *)shareReadInfoManager {
    
    static ReadInfoManager *shareReadInfo = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareReadInfo = [[ReadInfoManager alloc] init];
        [shareReadInfo reloadData];
    });
    return shareReadInfo;
}


- (id)init {
    
    self = [super init];
    if (self) {
        
        ReadInfo *readInfo = [[DBInterfaceFactory readInfoDBInterface] getReadInfo];
        
        self.fontSize = readInfo.fontSize;
        [self handleBackground:readInfo.backgroundColorID];
        self.lastBackgroundID = self.backgroundID;
        self.light = readInfo.screenLight;
        self.pageMethod = readInfo.pageMethod;
        
        [self reloadData];
    }
    
    return self;
}

- (void)reloadData {

    self.eachRowNums = kWidth/self.fontSize;
    self.rowNums = kHeight/self.fontSize;
    self.maxNumCharacter = (kWidth/self.fontSize) * (kHeight/self.fontSize);
    self.leftPadding = fmodf(kWidth, self.fontSize)/2;
    self.topPadding = fmodf(kHeight, self.fontSize)/2;
}

- (void)handleBackground:(NSInteger)backgroundID {
    
    self.lastBackgroundID = self.backgroundID;
    self.backgroundID = backgroundID;
    //共四种
    switch (backgroundID) {
        case 0:
            self.backgroundColor = [UIColor colorWithHex:0xeff2eb];
            self.fontColor = [UIColor blackColor];
            break;
            
        case 1:
            self.backgroundColor = [UIColor colorWithHex:0xf4ecd7];
            self.fontColor = [UIColor blackColor];
            break;
            
        case 2:
            self.backgroundColor = [UIColor colorWithHex:0xbfd6c2];
            self.fontColor = [UIColor blackColor];
            break;
            
        case 3:
            self.backgroundColor = [UIColor colorWithHex:0x1a2020];
            self.fontColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

- (void)updateReadInfo {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DBInterfaceFactory readInfoDBInterface] setFontSize:self.fontSize];
        [[DBInterfaceFactory readInfoDBInterface] setBackgroundColor:self.backgroundID];
        [[DBInterfaceFactory readInfoDBInterface] setPageMethod:self.pageMethod];
        [[DBInterfaceFactory readInfoDBInterface] setScreenLight:(NSInteger)self.light];
    });
}

- (void)setScreenLight:(CGFloat)light {
    
    self.light = light;
}

- (void)lessFont {
    
    //最小为10
    if (self.fontSize != 10) {
        self.fontSize -= 2;
        [self reloadData];
    }
}

- (void)addFont {
    
    //最大为20
    if (self.fontSize != 20) {
        self.fontSize += 2;
        [self reloadData];
    }
}

- (void)changePageMethod:(NSInteger)pageMethod {
    
    self.pageMethod = pageMethod;
    //改变方野方式
}

- (void)changeBackgroundColor:(NSInteger)colorID {
    
    [self handleBackground:colorID];
}

- (void)restoreLastColor {
    
    [self handleBackground:self.lastBackgroundID];
}

@end
