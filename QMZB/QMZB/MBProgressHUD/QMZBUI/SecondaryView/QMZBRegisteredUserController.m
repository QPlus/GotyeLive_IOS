//
//  QMZBRegisteredUserController.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBRegisteredUserController.h"
#import "QMZBUIUtil.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "NSString+Extension.h"
#import "QMZBUserInfo.h"
#import "QMZBLoginTextField.h"

@interface QMZBRegisteredUserController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    BOOL _isLoading;
    MBProgressHUD *HUD;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@property (nonatomic, strong) QMZBLoginTextField *userName;

@property (nonatomic, strong) QMZBLoginTextField *password;

@property (nonatomic, strong) QMZBLoginTextField *userphone;

@property (nonatomic, strong) QMZBLoginTextField *usermail;

@end

@implementation QMZBRegisteredUserController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
}

// 初始化导航条
- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
    backBtn.layer.cornerRadius = 3;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *userLogin = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, 90, ScreenWidth/3, 40)];
    userLogin.text = @"用户注册";
    userLogin.font = [UIFont boldSystemFontOfSize:18.0f];
    userLogin.textAlignment = NSTextAlignmentCenter;
    userLogin.textColor = WHITE_COLOR;
    [self.view addSubview:userLogin];
    
    _userName = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, 140,  ScreenWidth- 36*2, 45)];
    [_userName textWithleftImage:@"login_ic_username" placeName:@"请输入用户名"];
    
    _password = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_userName.frame) + 20, ScreenWidth - 36*2, 45)];
    _password.secureTextEntry = YES;
    [_password textWithleftImage:@"login_ic_password" placeName:@"请输入密码"];
    
    [self.view addSubview:_userName];
    [self.view addSubview:_password];
    
    _userphone = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_password.frame) + 20,  ScreenWidth- 36*2, 45)];
    [_userphone textWithleftImage:@"login_ic_userphone" placeName:@"请输入手机号码"];
    
    _usermail = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_userphone.frame) + 20, ScreenWidth - 36*2, 45)];
    [_usermail textWithleftImage:@"login_ic_usermail" placeName:@"请输入邮箱"];
    
    [self.view addSubview:_userphone];
    [self.view addSubview:_usermail];
    
    
    _userName.layer.cornerRadius = 5.0f;
    
    _password.layer.cornerRadius = 5.0f;
    _password.secureTextEntry = YES;

    _userphone.layer.cornerRadius = 5.0f;
    _userphone.delegate = self;
    
    _usermail.layer.cornerRadius = 5.0f;
    _usermail.delegate = self;
    
    UIButton *registbutton = [[UIButton alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_usermail.frame) + 20, ScreenWidth - 36*2, 45)];
    registbutton.layer.masksToBounds = NO;
    [registbutton setAdjustsImageWhenHighlighted:NO];
    registbutton.backgroundColor = COLOR(214, 214, 214, 0.3);
    registbutton.layer.borderColor = [[UIColor clearColor] CGColor];
    registbutton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [registbutton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [registbutton setTitle:@"注册" forState:UIControlStateNormal];
    [registbutton addTarget:self action:@selector(clickRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registbutton];
    
    UILabel *userhasAccount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, CGRectGetMaxY(registbutton.frame) + 10, 80, 40)];
    userhasAccount.text = @"已有账号?";
    userhasAccount.font = [UIFont boldSystemFontOfSize:14.0f];
    userhasAccount.textColor = WHITE_COLOR;
    [self.view addSubview:userhasAccount];
    
    UIButton *getBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/3+80, CGRectGetMaxY(registbutton.frame) + 10, 100, 40)];
    getBackbutton.layer.masksToBounds = NO;
    [getBackbutton setAdjustsImageWhenHighlighted:NO];
    getBackbutton.backgroundColor = [UIColor clearColor];
    getBackbutton.layer.borderColor = [[UIColor clearColor] CGColor];
    getBackbutton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [getBackbutton setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [getBackbutton setTitle:@"点击登录" forState:UIControlStateNormal];
    getBackbutton.tag = 301;
    getBackbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [getBackbutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBackbutton];
    
    //点击空白处收回键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark 点击空白处收回键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_userphone resignFirstResponder];
    [_usermail resignFirstResponder];
}

// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
#pragma mark - TextField Delegate

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 72 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

- (void)clickRegister:(id)sender
{
    if (_userName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_userphone.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
//    if (![NSString validateMobile:_userphone.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    if (![NSString validateEmail:_usermail.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    if (_usermail.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_password.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_userName.text forKey:@"account"];
    [parameters setObject:_password.text forKey:@"password"];
    [parameters setObject:_usermail.text forKey:@"email"];
    [parameters setObject:_userphone.text forKey:@"phone"];
//    parameters = [NSString stringWithFormat:@"username=%@&phone=%@&email=%@&password=%@",_userName.text ,_userphone.text,_usermail.text ,_password.text];
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/Register" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
            return;
        }
        NSDictionary *dics = back;
        NSLog(@"%@", dics);
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            [HUD hide:YES];
//            [self loginUser];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = @"注册成功！";
            [self dismissViewControllerAnimated:YES completion:^(){}];

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


- (void)loginUser
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:_userphone.text forKey:@"account"];
    [parameters setObject:_password.text forKey:@"password"];
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
            [userInfo setUserInfoLogin:_userphone.text withPassWord:_password.text ];
            AppDelegateInstance.userInfo = userInfo;
            
            [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"%d", 0]];
            [self dismissViewControllerAnimated:YES completion:^(){}];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}




@end
