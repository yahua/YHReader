//
//  NetBook.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-18.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "NetBook.h"

@implementation NetBook

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.bookName = [aDecoder decodeObjectForKey:@"bookName"];
    self.bookImageName = [aDecoder decodeObjectForKey:@"bookImageName"];
    self.bookSize = [aDecoder decodeObjectForKey:@"bookSize"];
    self.isLocal = [aDecoder decodeBoolForKey:@"isLocal"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.bookName forKey:@"bookName"];
    [aCoder encodeObject:self.bookImageName forKey:@"bookImageName"];
    [aCoder encodeObject:self.bookSize forKey:@"bookSize"];
    [aCoder encodeBool:self.isLocal forKey:@"isLocal"];
}

@end
