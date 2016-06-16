//
//  WSAds.m
//  网易新闻
//
//  Created by lyj on 15/12/29.
//  Copyright © 2015年 lyj. All rights reserved.
//

#import "WSAds.h"

@implementation WSAds

+ (instancetype)adsWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];

    return obj;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

@end
