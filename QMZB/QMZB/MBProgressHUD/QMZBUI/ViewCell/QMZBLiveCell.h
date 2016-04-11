//
//  QMZBLiveCell.h
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMZBLiveListModel.h"

typedef void(^DidSelectedButton)(UIButton *button);

@interface QMZBLiveCell : UITableViewCell

@property (nonatomic, strong) UILabel * userName;//直播室名称

@property (nonatomic, strong) UILabel * liveRoomTopic;//演讲的题目

@property (nonatomic, strong) UIImageView * headImage;//主播头像

@property (nonatomic, strong) UILabel * followCount;//被关注量

@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) UIImageView * isOnlive;//直播中

@property (nonatomic, copy) DidSelectedButton didSelectedButton;

@property (nonatomic, retain) QMZBLiveListModel *listModel;

- (void)fillCellWithObject:(id)object;

@end
