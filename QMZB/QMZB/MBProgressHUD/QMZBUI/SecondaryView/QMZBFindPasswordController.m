//
//  QMZBFindPasswordController.m
//  QMZB
//
//  Created by Jim on 16/4/5.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBFindPasswordController.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "QMZBUserInfo.h"
#import "QMZBLoginTextField.h"
#import "QMZBUIUtil.h"
#import "NSString+Extension.h"
#define kWidthWin self.view.frame.size.width - 36*2

@interface QMZBFindPasswordController ()<MBProgressHUDDelegate>
{
    BOOL _isLoading;
    
    NSInteger _requestType;
    
    NSInteger _correct;
    
    MBProgressHUD *HUD;
}

// 用户名框
@property (nonatomic, strong) QMZBLoginTextField *nameWindow;

// 验证码
//@property (nonatomic, strong) LoginWindowTextField *verificationWindow;
//
//// 获取验证码
//@property (nonatomic, strong) UIButton *verificationBtn;

// 密码框
@property (nonatomic, strong) QMZBLoginTextField *passWindow1;

// 密码框
@property (nonatomic, strong) QMZBLoginTextField *passWindow2;

//
@property (nonatomic, strong) UIButton *submitBtn;


@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBFindPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initContentView];
}

// 初始化导航条
- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
//    self.title = @"找回密码";
//    self.view.backgroundColor = COLOR(214, 231, 233, 1);
//    [self.navigationController.navigationBar setBarTintColor:BACKGROUND_DARK_COLOR];
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      TEXT_DARK_COLOR, NSForegroundColorAttributeName,
//                                                                      [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
//    
//    // 导航条 左边 返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
//    backItem.tintColor = TEXT_DARK_COLOR;
//    backItem.tag = 1;
//    [self.navigationItem setLeftBarButtonItem:backItem];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImage.image = [UIImage imageNamed:@"loginbg"];
    [self.view addSubview:bgImage];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
    backBtn.layer.cornerRadius = 3;
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"ab_ic_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *userLogin = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, 90, ScreenWidth/3, 40)];
    userLogin.text = @"找回密码";
    userLogin.font = [UIFont boldSystemFontOfSize:18.0f];
    userLogin.textAlignment = NSTextAlignmentCenter;
    userLogin.textColor = WHITE_COLOR;
    [self.view addSubview:userLogin];
}

// 初始化内容详情
- (void)initContentView
{
    
    // 用户名 输入框
    _nameWindow = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, 140, kWidthWin, 45)];
    [_nameWindow textWithleftImage:@"login_ic_username" placeName:@"请输入您常用的电话号码"];
    _nameWindow.keyboardType = UIKeyboardTypeNumberPad;
    
    // 密码 输入框
    _passWindow1 = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_nameWindow.frame) + 16, kWidthWin, 45)];
    _passWindow1.secureTextEntry = YES;
    [_passWindow1 textWithleftImage:@"login_ic_password" placeName:@"请输入密码"];
    
    // 密码 输入框
    _passWindow2 = [[QMZBLoginTextField alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_passWindow1.frame) + 16, kWidthWin, 45)];
    _passWindow2.secureTextEntry = YES;
    [_passWindow2 textWithleftImage:@"login_ic_password" placeName:@"请再次输入密码"];
    
    [self.view addSubview:_nameWindow];
    [self.view addSubview:_passWindow1];
    [self.view addSubview:_passWindow2];
    

    
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(_passWindow2.frame) + 40, kWidthWin, 35)];
    _submitBtn.layer.borderWidth = 1;
    _submitBtn.layer.cornerRadius = 5.0;
    _submitBtn.layer.masksToBounds = YES;
    [_submitBtn setAdjustsImageWhenHighlighted:NO];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _submitBtn.backgroundColor = COLOR(214, 214, 214, 0.3);
    _submitBtn.layer.borderColor = COLOR(214, 214, 214, 0.3).CGColor;
    [_submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_submitBtn];
    
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
    [_nameWindow resignFirstResponder];
    [_passWindow1 resignFirstResponder];
    [_passWindow2 resignFirstResponder];
}


#pragma mark 按钮点击事件
- (void)backBtnClick:(UIButton *)but
{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//  提交
- (void)submitClick
{
    [self keyboardHide:nil];// 关闭键盘
    
    if ([_nameWindow.text isEqualToString:@""]) {
        NSLog(@"请输入账户名称");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账户名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // 重设密码
    if ([_passWindow1.text isEqualToString:@""]) {
        NSLog(@"请输入密码");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([_passWindow2.text isEqualToString:@""]) {
        NSLog(@"请输入密码确认");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码确认" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if(![_passWindow1.text isEqualToString:_passWindow2.text]){
        NSLog(@"两次密码输入不一致");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码与确认密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // 验证过验证码，重设密码
    if (!_isLoading) {
        // 账号：1  密码：1
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *name = _nameWindow.text;
        NSString *password = _passWindow1.text;
        
        [parameters setObject:name forKey:@"phone"];
        [parameters setObject:password forKey:@"password"];
        
        if (_requestClient == nil) {
            _requestClient = [[QMZBNetwork alloc] init];
        }
        [self startRequest];
        [_requestClient postddByByUrlPath:@"/live/ModifyUserPwd" andParams:parameters andCallBack:^(id back) {
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
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                [alert show];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0];

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
//    }
    
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert) {
        
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
