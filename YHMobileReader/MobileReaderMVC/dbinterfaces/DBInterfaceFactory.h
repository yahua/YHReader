//
//  DBInterfaceFactory.h
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-17.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassifyDBInterface.h"
#import "RackDBInterface.h"
#import "BookDBInterface.h"
#import "BookMarkDBInterface.h"
#import "ReadInfoDBInterface.h"

@interface DBInterfaceFactory : NSObject

+ (id<ClassifyDBInterface>)classifyDBInterface;

+ (id<RackDBInterface>)rackDBInterface;

+ (id<BookDBInterface>)bookDBInterface;

+ (id<BookMarkDBInterface>)bookMarkDBInterface;

+ (id<ReadInfoDBInterface>)readInfoDBInterface;

@end
