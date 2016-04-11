//
//  QMZBUserInfo.h
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMZBUserInfo : NSObject

@property(nonatomic,assign)BOOL isLogin;

#pragma mark 用户信息
@property (nonatomic, strong) NSString * userPhone;
@property (nonatomic, strong) NSString * passWord;
@property (nonatomic, strong) NSString * channelID;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * emailAddress;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * sessionId;
@property (nonatomic, strong) NSString * liveRoomId;
@property (nonatomic, strong) NSString * headerpicId;
@property (nonatomic, strong) NSString * sex;

//MyLiveRoomInfo主播密码
@property (nonatomic, strong) NSString * liveRoomanchorPwd;//主播密码密码
@property (nonatomic, strong) NSString * liveRoomUserPwd;//观看直播的用户密码
@property (nonatomic, strong) NSString * liveRoomName;//直播室名称
@property (nonatomic, strong) NSString * liveRoomDesc;//直播室描述
@property (nonatomic, strong) NSString * liveRoomTopic;//演讲的题目
@property (nonatomic, strong) NSString * anchorIcon;//主播头像
@property (nonatomic, strong) NSString * focusCount;//被关注量

//+(instancetype)sheardUserInfo;

- (void)setUserInfoLogin:(NSString *)account
            withPassWord:(NSString *)passWord;

- (void)userLogout;


@end
