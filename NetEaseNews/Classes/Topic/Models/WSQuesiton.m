//
//  WSQuesiton.m
//  网易新闻
//
//  Created by lyj on 16/1/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import "WSQuesiton.h"

@implementation WSQuesiton

+ (instancetype)quesitonWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

@end