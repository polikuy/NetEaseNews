//
//  WSVideoCell.h
//  网易新闻
//
//  Created by lyj on 16/1/11.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSVideo;

@interface WSVideoCell : UITableViewCell

@property (strong, nonatomic) WSVideo *video;

+ (instancetype)videoCellWithTableView:(UITableView *)tableView;

+ (CGFloat)rowHeight;

@end
