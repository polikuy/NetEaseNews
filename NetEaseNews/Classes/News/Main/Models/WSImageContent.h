//
//  WSImageContent.h
//  网易新闻
//
//  Created by lyj on 16/1/2.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSGetDataTool.h"

@interface WSImageContent : NSObject

// postID
@property (nonatomic, copy) NSString *postid;
// nil
@property (nonatomic, copy) NSString *series;
// 描述
@property (nonatomic, copy) NSString *desc;
// 发布日期
@property (nonatomic, copy) NSString *datatime;
// 创建日期
@property (nonatomic, copy) NSString *createdate;

@property (nonatomic, copy) NSString *relatedids;
// 蒙板背景图
@property (nonatomic, copy) NSString *scover;
// nil
@property (nonatomic, copy) NSString *autoid;
// 新闻原地址
@property (nonatomic, copy) NSString *url;
// 编辑
@property (nonatomic, copy) NSString *creator;

/** 里面装的是SXPhotosDetail对象*/
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *reporter;
// 标题
@property (nonatomic, copy) NSString *setname;
// 封面
@property (nonatomic, copy) NSString *cover;
// 评论地址
@property (nonatomic, copy) NSString *commenturl;
// 来源
@property (nonatomic, copy) NSString *source;
// tag
@property (nonatomic, copy) NSString *settag;
// photoview_bbs 未知
@property (nonatomic, copy) NSString *boardid;

@property (nonatomic, copy) NSString *tcover;
// 图片数
@property (nonatomic, copy) NSNumber *imgsum;

@property (nonatomic,copy) NSString *clientadurl;

+ (instancetype)imageContentWithDict:(NSDictionary *)dict;

+ (void)imageContentWithPhotoID:(NSString *)photoid getDataSuccess:(void (^)(WSImageContent *content))success getDataFailure:(GetDataFailureBlock)failure;

@end
