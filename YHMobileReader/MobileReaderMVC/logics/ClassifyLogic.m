//
//  ClassifyLogic.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-22.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "ClassifyLogic.h"

@implementation ClassifyLogic

+(NSInteger)getBlogTextlength:(NSString *)blogText{
    
    int i,n=[blogText length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[blogText characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

@end
