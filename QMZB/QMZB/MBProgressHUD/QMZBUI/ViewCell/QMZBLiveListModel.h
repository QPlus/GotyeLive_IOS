//
//  QMZBLiveListModel.h
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMZBLiveListModel : NSObject

@property (nonatomic, strong) NSString * liveRoomId;//
@property (nonatomic, strong) NSString * liveRoomanchorPwd;//主播密码
@property (nonatomic, strong) NSString * liveRoomUserPwd;//观看直播的用户密码
@property (nonatomic, strong) NSString * liveRoomName;//直播室名称
@property (nonatomic, strong) NSString * liveRoomDesc;//直播室描述
@property (nonatomic, strong) NSString * liveRoomTopic;//演讲的题目
@property (nonatomic, strong) NSString * anchorName;//主播昵称
@property (nonatomic, strong) NSString * anchorIcon;//主播头像
@property (nonatomic, strong) NSString * followCount;//被关注量
@property (nonatomic, strong) NSString * isFollow;//关注
@property (nonatomic, strong) NSString * playerCount;//
@property (nonatomic, strong) NSString * isplay;//

@end
