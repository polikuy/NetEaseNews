//
//  WSImageCell.h
//  网易新闻
//
//  Created by lyj on 16/1/5.
//  Copyright © 2016年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSImageContent;

@interface WSImageCell : UICollectionViewCell

@property (strong, nonatomic) WSImageContent *imageContent;

@property (assign, nonatomic) NSIndexPath *indexPath;

@end
