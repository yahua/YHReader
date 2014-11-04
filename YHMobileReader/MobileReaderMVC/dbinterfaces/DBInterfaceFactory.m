//
//  DBInterfaceFactory.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-17.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "DBInterfaceFactory.h"
#import <objc/runtime.h>

#define kDispatchAllocSingleton(instance, implement) \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[objc_getClass(implement) alloc] init];\
});


@implementation DBInterfaceFactory

+ (id<ClassifyDBInterface>)classifyDBInterface {
    
    kDispatchAllocSingleton(instance, "ClassifyDBImplement");
    
    return instance;
}

+ (id<RackDBInterface>)rackDBInterface {
    
    kDispatchAllocSingleton(instance, "RackDBImplement");
    
    return instance;
}

+ (id<BookDBInterface>)bookDBInterface {
    
    kDispatchAllocSingleton(instance, "BookDBImplement");
    
    return instance;
}

+ (id<BookMarkDBInterface>)bookMarkDBInterface {
    
    kDispatchAllocSingleton(instance, "BookMarkDBImplement");
    
    return instance;
}

+ (id<ReadInfoDBInterface>)readInfoDBInterface {
    
    kDispatchAllocSingleton(instance, "ReadInfoImplement");
    
    return instance;
}

@end
