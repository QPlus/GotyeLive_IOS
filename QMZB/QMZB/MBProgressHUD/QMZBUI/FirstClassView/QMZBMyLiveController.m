//
//  QMZBMyLiveController.m
//  QuanMingZhiBo
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBMyLiveController.h"
#import "QMZBUIUtil.h"
#import "MBProgressHUD.h"
#import "GLCore.h"
#import "GLChatSession.h"
#import "GLPublisher.h"
#import "QMZBUserInfo.h"
#import "GLRoomSession.h"
#import "GLChatSession.h"
#import "GLRoomPlayer.h"
#import "GLRoomPublisher.h"
#import "GLRoomPublisherDelegate.h"
#import "QMZBChatViewController.h"
#import "QMZBRegisterChannelController.h"

@interface QMZBMyLiveController ()
{
    GLAuthToken *_authToken;
}
@property (nonatomic,copy)GLRoomPublisher *publisher;

@property (nonatomic,copy)GLRoomPlayer *player;

@property (nonatomic,copy)GLChatSession *chatKit;

@property (nonatomic,copy)GLRoomSession * session;

@end

@implementation QMZBMyLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//
//    self.navigationController.navigationBar.translucent =NO;
    [self.navigationController.navigationBar setBarTintColor: [UIColor blackColor]];
//
    self.view.backgroundColor = [UIColor blackColor];

//    [self loginRoom];
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:NO];
//    if (![AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
//        AppDelegateInstance.allowRotation = YES;
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        QMZBChatViewController *loginController = [story instantiateViewControllerWithIdentifier:@"chatView"];
//        loginController.isLiveMode = 1;
//        loginController.itemTag = 100;
//        loginController.roomId = AppDelegateInstance.userInfo.liveRoomId;
//        loginController.password = AppDelegateInstance.userInfo.liveRoomanchorPwd;
//        loginController.nickName = AppDelegateInstance.userInfo.nickName;
//        [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        
//        [self presentViewController:loginController animated:NO completion:nil];
//    }else {
//        
//        QMZBRegisterChannelController *channel = [[QMZBRegisterChannelController alloc] init];
//        UINavigationController *channelNavigation = [[UINavigationController alloc] initWithRootViewController:channel];
//        [channel setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        
//        channel.itemTag = 100;
//        [self presentViewController:channelNavigation animated:YES completion:nil];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
