//
//  WSTopicDetailCell.h
//  网易新闻
//
//  Created by lyj on 16/1/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSTopicDetail;

@interface WSTopicDetailCell : UITableViewCell

@property (strong, nonatomic) WSTopicDetail *topicDetail;

+ (instancetype)topicDetalWithTableView:(UITableView *)tableView;

@end
