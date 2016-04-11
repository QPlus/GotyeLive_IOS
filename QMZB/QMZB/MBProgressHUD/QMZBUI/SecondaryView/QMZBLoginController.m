//
//  QMZBLoginController.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBLoginController.h"
#import "QMZBRegisteredUserController.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "QMZBUserInfo.h"
#import "QMZBLoginTextField.h"
#import "QMZBUIUtil.h"
#import "NSString+Extension.h"
#import "QMZBFindPasswordController.h"

@interface QMZBLoginController ()<MBProgressHUDDelegate>
{
    BOOL _isLoading;
    MBProgressHUD *HUD;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@property (nonatomic, strong) QMZBLoginTextField *nameWindow;

@property (nonatomic, strong) QMZBLoginTextField *passwordWindow;

@end

@implementation QMZBLoginController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (AppDelegateInstance.userInfo.sessionId) {
//        [self dismissViewControllerAnimated:YES completion:^(){}];

    }
}

- (void)initView
{

    UILabel *userLogin = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, 110, ScreenWidth/3, 40)];
    userLogin.text = @"用户登录";
    userLogin.font = [UIFont boldSystemFontOfSize:18.0f];
    userLogin.textColor = WHITE_COLOR;
    userLogin.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:userLogin];
    // 用户名 输入框
    _nameWindow = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, 180,  ScreenWidth- 36*2, 45)];
    [_nameWindow textWithleftImage:@"login_ic_username" placeName:@"手机/邮箱/用户名"];
    
    // 密码 输入框
    _passwordWindow = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_nameWindow.frame) + 20, ScreenWidth - 36*2, 45)];
    _passwordWindow.secureTextEntry = YES;
    [_passwordWindow textWithleftImage:@"login_ic_password" placeName:@"密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passwordWindow];
    
    UIButton *loginbutton = [[UIButton alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_passwordWindow.frame) + 20, ScreenWidth - 36*2, 45)];
    loginbutton.layer.masksToBounds = NO;
    [loginbutton setAdjustsImageWhenHighlighted:NO];
    loginbutton.backgroundColor = COLOR(214, 214, 214, 0.3);
    loginbutton.layer.borderColor = [[UIColor clearColor] CGColor];
    loginbutton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [loginbutton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [loginbutton setTitle:@"登录" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
    
    UIButton *getregistbutton = [[UIButton alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(loginbutton.frame) + 20, 100, 30)];
    getregistbutton.layer.masksToBounds = NO;
    [getregistbutton setAdjustsImageWhenHighlighted:NO];
    getregistbutton.backgroundColor = [UIColor clearColor];
    getregistbutton.layer.borderColor = [[UIColor clearColor] CGColor];
    getregistbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [getregistbutton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [getregistbutton setTitle:@"手机快速注册" forState:UIControlStateNormal];
    getregistbutton.tag = 302;
    [getregistbutton addTarget:self action:@selector(getBackPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getregistbutton];
    
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginbutton.frame) - 100, CGRectGetMaxY(loginbutton.frame) + 20, 100, 30)];
    getBackbutton.layer.masksToBounds = NO;
    [getBackbutton setAdjustsImageWhenHighlighted:NO];
    getBackbutton.backgroundColor = [UIColor clearColor];
    getBackbutton.layer.borderColor = [[UIColor clearColor] CGColor];
    getBackbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [getBackbutton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [getBackbutton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    getBackbutton.tag = 301;
    [getBackbutton addTarget:self action:@selector(getBackPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBackbutton];


    loginbutton.layer.cornerRadius = 5.0f;
    
    //点击空白处收回键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

// 找回密码
- (void)getBackPassword:(UIButton *)button
{
    if (button.tag == 301) {
        
        QMZBFindPasswordController *findPassword = [[QMZBFindPasswordController alloc] init];
//        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:findPassword];
        [findPassword setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:findPassword animated:YES completion:nil];
    }else {
        
        QMZBRegisteredUserController *registeredUser = [[QMZBRegisteredUserController alloc] init];
        [registeredUser setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:registeredUser];
        [self presentViewController:registeredUser animated:YES completion:nil];
    }
}

#pragma mark 点击空白处收回键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_nameWindow resignFirstResponder];
    [_passwordWindow resignFirstResponder];

}

#pragma 登录按钮
- (void)clickLogin:(UIButton *)sender
{
//    NSLog(@"--------");

    
    if (_nameWindow.text.length == 0 || _passwordWindow.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_nameWindow.text forKey:@"account"];
    [parameters setObject:_passwordWindow.text forKey:@"password"];
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/Login" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
            return;
        }
        NSDictionary *dics = back;
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            [HUD hide:YES];
            
            NSLog(@"%@", dics);
            QMZBUserInfo *userInfo = [[QMZBUserInfo alloc] init];
            userInfo.userName = [NSString jsonUtils:[dics objectForKey:@"account"]];
            userInfo.nickName = [NSString jsonUtils:[dics objectForKey:@"nickName"]];
            userInfo.liveRoomId = [NSString jsonUtils:[dics objectForKey:@"liveRoomId"]];
            userInfo.sessionId = [NSString jsonUtils:[dics objectForKey:@"sessionId"]];
            userInfo.headerpicId = [NSString jsonUtils:[dics objectForKey:@"headPicId"]];
            userInfo.sex = [NSString jsonUtils:[dics objectForKey:@"sex"]];
            userInfo.isLogin = YES;
            [userInfo setUserInfoLogin:_nameWindow.text withPassWord:_passwordWindow.text ];
            AppDelegateInstance.userInfo = userInfo;
            if (![AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
                NSLog(@"%@",AppDelegateInstance.userInfo.liveRoomId);
                [self getMyLiveRoom];
            }else {
                
                [self dismissViewControllerAnimated:YES completion:^(){}];
            }
            NSNotification *notification =[NSNotification notificationWithName:NotificationloginSeccess object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else {
            // 错误返回码
            NSString *msg = [dics objectForKey:@"desc"];
            NSLog(@"未返回正确的数据：%@", msg);
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = msg;
        }
        _isLoading  = NO;
    }];
}
- (void)getMyLiveRoom
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/GetMyLiveRoom" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
            return;
        }
        NSDictionary *dics = back;
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            [HUD hide:YES];
            
            NSLog(@"%@", dics);
            AppDelegateInstance.userInfo.liveRoomId = [NSString jsonUtils:[dics objectForKey:@"liveRoomId"]];
            AppDelegateInstance.userInfo.liveRoomanchorPwd = [NSString jsonUtils:[dics objectForKey:@"liveRoomAnchorPwd"]];
            AppDelegateInstance.userInfo.liveRoomUserPwd = [NSString jsonUtils:[dics objectForKey:@"liveRoomUserPwd"]];
            AppDelegateInstance.userInfo.liveRoomName = [NSString jsonUtils:[dics objectForKey:@"liveRoomName"]];
            AppDelegateInstance.userInfo.liveRoomDesc = [NSString jsonUtils:[dics objectForKey:@"liveRoomDesc"]];
            AppDelegateInstance.userInfo.liveRoomTopic = [NSString jsonUtils:[dics objectForKey:@"liveRoomTopic"]];
            AppDelegateInstance.userInfo.anchorIcon = [NSString jsonUtils:[dics objectForKey:@"anchorIcon"]];
            AppDelegateInstance.userInfo.focusCount = [NSString jsonUtils:[dics objectForKey:@"focusCount"]];
            
            [self dismissViewControllerAnimated:YES completion:^(){}];
        }else {
            // 错误返回码
            NSString *msg = [dics objectForKey:@"msg"];
            NSLog(@"未返回正确的数据：%@", msg);
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = msg;
        }
        _isLoading  = NO;
    }];
    
}



-(void) startRequest
{
    _isLoading = YES;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载...";
    HUD.delegate = self;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
