//
//  QMZBTabViewController.m
//  QuanMingZhiBo
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBTabViewController.h"
#import "QMZBMyLiveController.h"
#import "QMZBSettingController.h"
#import "QMZBLiveViewController.h"
#import "QMZBUIUtil.h"
#import "QMZBItemView.h"
#import "QMZBChatViewController.h"
#import "QMZBLoginController.h"
#import "QMZBUserInfo.h"
#import "QMZBRegisterChannelController.h"
#import "NSString+Extension.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"

#define kTagItem 100

@interface QMZBTabViewController ()<QMZBItemViewDelegate,UITabBarDelegate,MBProgressHUDDelegate>
{
    BOOL _isLoading;
    MBProgressHUD *HUD;
     NSInteger _itemtag;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;


@end

@implementation QMZBTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 加载子视图控制器
    [self loadViewControllers];
    
    // 自定义QMZBLoginController
    [self customTabBarView];
 
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateSelectedItem:) name:NotificationUpdateTab object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(userlevle:) name:NotificationLevelRoom object:nil];

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!AppDelegateInstance.userInfo.isLogin) {
        
//        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
//        
//        if (![account isEmpty]) {
//            [self reLogin];
//        }else {
//            
//        }
        QMZBLoginController *loginController = [[QMZBLoginController alloc] init];
        [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentViewController:loginController animated:NO completion:nil];
    }
    
}

-(void) userlevle:(NSNotification *)notification
{
    if (!AppDelegateInstance.userInfo.isLogin) {
        
        QMZBLoginController *loginController = [[QMZBLoginController alloc] init];
        [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
//        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:loginController animated:NO completion:nil];
    }
    
}

-(void) updateSelectedItem:(NSNotification *)notification
{
    NSString *itemIndex = (NSString *)[notification object];
    
    [self setTabIndex:[itemIndex intValue]];
    _itemtag = [itemIndex intValue];

}

- (void)didSelectItemView:(QMZBItemView *)itemView
{
    [self setTabIndex:itemView.tag];
    if (itemView.tag == 101) {
        if (![AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
            AppDelegateInstance.allowRotation = YES;
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            QMZBChatViewController *loginController = [story instantiateViewControllerWithIdentifier:@"chatView"];
            loginController.isLiveMode = 1;
            loginController.itemTag = _itemtag;
            loginController.roomId = AppDelegateInstance.userInfo.liveRoomId;
            loginController.password = AppDelegateInstance.userInfo.liveRoomanchorPwd;
            loginController.nickName = AppDelegateInstance.userInfo.nickName;
            [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self presentViewController:loginController animated:NO completion:nil];
        }else {
            
            QMZBRegisterChannelController *channel = [[QMZBRegisterChannelController alloc] init];
            [channel setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            channel.itemTag = _itemtag;
            [self presentViewController:channel animated:YES completion:nil];
        }
        
    }else {
        
    }
    _itemtag = itemView.tag;
    
}

-(void) setTabIndex:(NSInteger)index
{
    if (self.selectedIndex == index) {
        return;
    }
    
    UIView *viewTemp = [self.tabBar viewWithTag:index];
    
    if ([viewTemp isMemberOfClass:[QMZBItemView class]]) {
        QMZBItemView *itemView = (QMZBItemView *)viewTemp;
        
        [UIView beginAnimations:@"Animation" context:(__bridge void *)(itemView.itemButton)];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        
        itemView.itemButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView commitAnimations];
        
        for (UIView *subview in self.tabBar.subviews) {
            
            if ([subview isMemberOfClass:[QMZBItemView class]]) {
                
                QMZBItemView *item = (QMZBItemView *)subview;
                if (item == itemView) {
                    [item isSelected:YES];
                }else {
                    [item isSelected:NO];
                }
            }
        }
        
        self.selectedIndex = index - kTagItem;
    }
}


- (void)customTabBarView
{
    // 1 移除UITabBarButton
    for (UIView *subView in [self.tabBar subviews]) {
        [subView removeFromSuperview];
    }
    
    // 2 添加背景视图
//    UIImageView *tabBarBG = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
   // tabBarBG.backgroundColor = WHITE_COLOR;
    UIImage *newimage = [UIImage imageNamed:@"tabbar_bg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(25, 25, 25, 25);
    UIImage *image = [newimage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
//    tabBarBG.image = image;
    [self.tabBar setBackgroundImage:image];
    [self.tabBar setShadowImage:[UIImage new]];
//    [self.tabBar addSubview:tabBarBG];
    

    // 按钮的宽度
    CGFloat itemWidth = ScreenWidth / [self.viewControllers count];
    
    NSArray *titles = @[@"直播", @"发布", @"我"];
    
    // 3 实例化按钮
    for (int i = 0; i < [[self viewControllers] count]; i++) {
        
        // 获取图片名字
        NSString *imageNamed = [NSString stringWithFormat:@"icon_tab_normal_0%d", i+1];
        NSString *imageSelectNamed = [NSString stringWithFormat:@"icon_tab_selected_0%d", i+1];
        NSString *title = titles[i];
        // 创建按钮
        QMZBItemView *wxItemView = [[QMZBItemView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 49)];
        // 设置代理
        wxItemView.delegate = self;
        wxItemView.tag = kTagItem + i;
        // 设置背景
        [wxItemView.itemButton setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
        [wxItemView.itemButton setImage:[UIImage imageNamed:imageSelectNamed] forState:UIControlStateSelected];
        // 设置内容
        wxItemView.textLabel.text = title;
        
        if (i == 0) {
            [wxItemView isSelected:YES];
            _itemtag = kTagItem + i;
        }
        
        // 添加子视图
        [self.tabBar addSubview:wxItemView];
        
    }
    
    
}


- (void)loadViewControllers
{
    // 1 创建直播页面
    QMZBLiveViewController *vc1 = [[QMZBLiveViewController alloc] init];
//    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:vc1];

    // 2 创建我要直播页面
    QMZBMyLiveController *vc2 = [[QMZBMyLiveController alloc] init];
//    UINavigationController *groundNav = [[UINavigationController alloc] initWithRootViewController:vc2];

    // 3 创建个人页面
    QMZBSettingController *vc3 = [[QMZBSettingController alloc] init];
//    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:vc3];

    
    // 将子视图控制器放入数组
//    NSArray *vcs = @[homeNav, groundNav, searchNav];
    NSArray *vcs = @[vc1, vc2, vc3];

    // 添加标签控制器
    [self setViewControllers:vcs animated:YES];

    
}
#pragma mark - Animation Delegate
- (void)animationWillStart:(NSString *)animationID context:(void *)context
{
    
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"Animation"]) {
        
        UIButton *button = (__bridge UIButton *)context;
        
        [UIView beginAnimations:nil context:NULL];
        // 还原成原来的状态
        button.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
}


-(void)reLogin//判断session Id过期
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] forKey:@"account"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"] forKey:@"password"];
    
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/Login" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            [HUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return ;
        }
        NSDictionary *dics = back;
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        [HUD hide:YES];
        if (result_type == 10000) {
            NSLog(@"%@", dics);
            QMZBUserInfo *userInfo = [[QMZBUserInfo alloc] init];
            userInfo.userName = [NSString jsonUtils:[dics objectForKey:@"account"]];
            userInfo.nickName = [NSString jsonUtils:[dics objectForKey:@"nickName"]];
            userInfo.liveRoomId = [NSString jsonUtils:[dics objectForKey:@"liveRoomId"]];
            userInfo.sessionId = [NSString jsonUtils:[dics objectForKey:@"sessionId"]];
            userInfo.headerpicId = [NSString jsonUtils:[dics objectForKey:@"headPicId"]];
            userInfo.sex = [NSString jsonUtils:[dics objectForKey:@"sex"]];
            userInfo.isLogin = YES;
            AppDelegateInstance.userInfo = userInfo;
            if (![AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
                [self getMyLiveRoom];
            }else {
                
            }
            NSNotification *notification =[NSNotification notificationWithName:NotificationloginSeccess object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else {
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = @"自动登录失败，请手动登录！";
            
            QMZBLoginController *loginController = [[QMZBLoginController alloc] init];
            [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            
            [self presentViewController:loginController animated:NO completion:nil];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
