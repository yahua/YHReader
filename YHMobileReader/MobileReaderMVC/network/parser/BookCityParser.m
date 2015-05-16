//
//  BookCityParser.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-28.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookCityParser.h"
#import "GDataXMLNode.h"
#import "NetBook.h"
#import "BookCityLogic.h"

@implementation BookCityParser


+ (NSArray *)parserBookInfo:(NSData *)data {
    
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *childArray = [xmlEle children];
    NSMutableArray *netBookArray = [NSMutableArray array];
    for (GDataXMLElement *element in childArray) {
        NSArray *bookPropertyArray = [element children];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (GDataXMLElement *bookelement in bookPropertyArray) {
            [dic setValue:[bookelement stringValue] forKey:bookelement.name];
        }
        NetBook *netBook = [[NetBook alloc] init];
        netBook.bookName = [dic objectForKey:@"bookName"];
        netBook.bookImageName = [dic objectForKey:@"bookImgName"];
        netBook.bookSize = [dic objectForKey:@"bookSize"];
        [BookCityLogic handleBookIslocal:netBook];
        
        [netBookArray addObject:netBook];
    }
    
    return netBookArray;
}

@end
