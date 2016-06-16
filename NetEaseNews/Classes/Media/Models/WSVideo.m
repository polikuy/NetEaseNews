


//
//  WSVideo.m
//  NetEaseNews
//
//  Created by lyj on 16/1/12.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import "WSVideo.h"

@implementation WSVideo

//进入“视听”控制器 请求视频
+ (void)videosWithIndex:(NSInteger)index cache:(BOOL)cache getDataSuccess:(GetDataSuccessBlock)success videoSidList:(void (^)(NSArray *))list getDataFailure:(GetDataFailureBlock)failure{
    //请求视频用到的接口 （两个参数）
    NSString *urlStr = [NSString stringWithFormat:@"nc/video/home/%ld-%ld.html",index , index+10];
    //使用af请求数据（封装）
    [WSGetDataTool GETJSON:urlStr GetDataType:WSGETDataTypeBaseURL progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // NSLog(@"11111%@",responseObject);
 
        //视频模块顶部数据
        if ([responseObject[@"videoSidList"] count] > 0) {
            
            list(responseObject[@"videoSidList"]);
        }
        
        
        NSArray *dictArr = responseObject[@"videoList"];
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArr) {
            
            WSVideo *video = [WSVideo videoWithDict:dict];
            [arrM addObject:video];
        }
        
        if (cache && arrM.count > 0) {
            
            [NSKeyedArchiver archiveRootObject:arrM toFile:[self cachePath]];
        }
        
        success(arrM.copy);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

+ (NSString *)cachePath{
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [filePath stringByAppendingPathComponent:@"video.data"];
}

+ (NSArray *)cacheData{
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePath]];
}


+ (instancetype)videoWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc] init];
    
    
    [obj setValuesForKeysWithDictionary:dict];
    [obj setDesc:dict[@"description"]];
    
    return obj;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
