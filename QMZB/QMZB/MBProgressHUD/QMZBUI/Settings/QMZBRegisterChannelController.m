//
//  QMZBRegisterChannelController.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBRegisterChannelController.h"
#import "QMZBUIUtil.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "QMZBUserInfo.h"
#import "NSString+Extension.h"

@interface QMZBRegisterChannelController ()<MBProgressHUDDelegate>
{
    BOOL _isLoading;
    MBProgressHUD *HUD;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBRegisterChannelController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
}
// 初始化导航条
- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent =NO;
    self.title = @"注册直播账号";
    self.view.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      WHITE_COLOR, NSForegroundColorAttributeName,
                                                                      [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    backItem.tintColor = WHITE_COLOR;
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //点击空白处收回键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _introduceText.layer.borderWidth = 0.5;
    _introduceText.layer.borderColor = DIVIDE_LINE_COLOR.CGColor;
}

#pragma mark 点击空白处收回键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_liveName resignFirstResponder];
    [_introduceText resignFirstResponder];
    
}

// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    if (_itemTag > 0) {
        [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"%ld", (long)_itemTag]];

    }
    [self dismissViewControllerAnimated:YES completion:^(){}];
//    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)applicationClick:(id)sender
{
    if (_liveName.text.length == 0 || _introduceText.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入直播室名称或介绍" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([_liveName.text isBlank]) {
        
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:@"" forKey:@"liveRoomanchorPwd"];
    [parameters setObject:@"" forKey:@"liveRoomUserPwd"];
    [parameters setObject:_liveName.text forKey:@"liveRoomName"];
    [parameters setObject:_introduceText.text forKey:@"liveRoomDesc"];

    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/CreateLiveRoom" andParams:parameters andCallBack:^(id back) {
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
            NSLog(@"===%@", AppDelegateInstance.userInfo.liveRoomId);
            
//            NSNotification *notification =[NSNotification notificationWithName:@"CreateLiveRoom" object:nil userInfo:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            if (_itemTag > 0) {
//                [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"%ld", (long)_itemTag]];
//                
//            }
//            [self dismissViewControllerAnimated:YES completion:^(){}];
            [self getMyLiveRoom];
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    _isLoading  = NO;
                    [self applicationClick:nil];
                }
            }];
            
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
            
            NSNotification *notification =[NSNotification notificationWithName:NotificationCreateLiveRoom object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            if (_itemTag > 0) {
                [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"%ld", (long)_itemTag]];
                
            }
//            [self.navigationController popToRootViewControllerAnimated:YES];

            [self dismissViewControllerAnimated:YES completion:^(){}];
            
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    _isLoading  = NO;
                    [self getMyLiveRoom];
                }
            }];
            
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

-(void) startRequest
{
    _isLoading = YES;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载...";
    HUD.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
