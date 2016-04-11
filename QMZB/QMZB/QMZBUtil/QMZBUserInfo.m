//
//  QMZBUserInfo.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBUserInfo.h"

//static QMZBUserInfo *_userInfo=nil;

@implementation QMZBUserInfo

//+ (instancetype)sheardUserInfo
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken,^{
//        _userInfo = [[QMZBUserInfo alloc] init];
//        _userInfo.channelID=[[NSUserDefaults standardUserDefaults] objectForKey:@"channelID"];
//        _userInfo.userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//        _userInfo.emailAddress=[[NSUserDefaults standardUserDefaults] objectForKey:@"emailAddress"];
//        _userInfo.passWord=[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
//        _userInfo.userPhone=[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"];
//        _userInfo.nickName=[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
//
//        
//        if(_userInfo.userPhone)
//        {
//            _userInfo.isLogin=YES;
//        }else
//        {
//            _userInfo.isLogin=NO;
//        }
//        
//    });
//    return _userInfo;
//}

- (void)setUserInfoLogin:(NSString *)account withPassWord:(NSString *)passWord

{
    
    if (account) {
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"account"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        self.userName = account;
    }
    if (passWord) {
        [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"passWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        self.passWord = passWord;
    }
    
    self.isLogin=YES;
}

- (void)userLogout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isLogin=NO;
    
}


@end
