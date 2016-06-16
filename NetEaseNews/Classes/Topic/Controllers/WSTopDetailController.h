//
//  WSTopDetailController.h
//  网易新闻
//
//  Created by lyj on 16/1/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSTopic;

@interface WSTopDetailController : UIViewController

@property (strong, nonatomic) WSTopic *topic;

+ (instancetype)topicDetailWithTopic:(WSTopic *)topic;

@end
