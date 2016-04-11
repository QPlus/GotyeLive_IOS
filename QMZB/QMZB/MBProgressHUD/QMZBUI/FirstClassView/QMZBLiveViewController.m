//
//  QMZBLiveViewController.m
//  QuanMingZhiBo
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBLiveViewController.h"
#import "QMZBUIUtil.h"
#import "QMZBChatViewController.h"
#import "MBProgressHUD.h"
#import "GLCore.h"
//#import "GLChatManager.h"
#import "GLPublisher.h"
#import "QMZBSortGroup.h"
#import "QMZBSortItem.h"
#import "MBProgressHUD.h"
#import "QMZBLiveListModel.h"
#import "QMZBLiveCell.h"
#import "MJRefresh.h"    //刷新
#import "QMZBNetwork.h"
#import "NSString+Extension.h"
#import "QMZBUserInfo.h"
#import "QMZBSeacherLiveController.h"

#define TYPE_TAB1 1
#define TYPE_TAB2 2
#define kTabHeight 40.f

@interface QMZBLiveViewController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>
{
    GLAuthToken *_authToken;
    
    QMZBSortGroup *_tabGrop;
    
    NSMutableArray *_tabArrays;// 排序View集合
    
    NSInteger _type;
    
    BOOL _isLoading;
    
    MBProgressHUD *HUD;

    NSInteger _pageIndex;

}

@property(nonatomic ,strong) UITableView *tableView;

@property (strong, nonatomic) UIView *tabContentView;

@property (nonatomic, strong) NSMutableArray *dataArrays;

@property (nonatomic, strong) NSMutableArray *onlineList;

@property (nonatomic, strong) NSMutableArray *offlineList;

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBLiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:NotificationloginSeccess object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateSelected:) name:NotificationUpdateTab object:nil];


}
- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent =NO;
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 1)];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
//    self.navigationItem.title = @"亲加全民直播";
//    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                      WHITE_COLOR, NSForegroundColorAttributeName,
//                                                                      [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
//    
//    // 导航条 左边 返回按钮
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_search"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
//    backItem.tintColor = TEXT_DARK_COLOR;
//    backItem.tag = 1;
//    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(ScreenWidth-50, 0, 35  , 35);
//    [search setTitle:@"搜索直播室" forState:UIControlStateNormal];
//    search.titleLabel.font = [UIFont systemFontOfSize:15];
//    [search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [search setImage:[UIImage imageNamed:@"ab_ic_search"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    search.tag = 1;
//    search.layer.borderWidth = 0.5f;
//    search.layer.borderColor = WHITE_COLOR.CGColor;
//    search.layer.cornerRadius = 5.f;
    [headerView addSubview:search];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth-100, 35)];
    titleLabel.text = [NSString stringWithFormat:@"亲加直播"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = WHITE_COLOR;
    [headerView addSubview:titleLabel];
    
    self.tabBarController.navigationItem.titleView = headerView;
}

-(void) updateSelected:(NSNotification *)notification
{
    NSString *itemIndex = (NSString *)[notification object];
    
    if ([itemIndex isEqualToString:@"100"]) {
        [self initNavigationBar];
    }else {
        
    }
    
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
#pragma mark 点击事件
// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    QMZBSeacherLiveController *controller = [[QMZBSeacherLiveController alloc] init];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self.navigationController pushViewController:controller animated:YES];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];

}


- (void)viewDidAppear:(BOOL)animated
{
    [self initNavigationBar];
}
- (void)notification:(NSNotification *)notification
{
    [self initView];
    [self initNavigationBar];
    [self.tableView headerBeginRefreshing];
}

- (void)initView
{
    
    _tabContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTabHeight)];
    _tabContentView.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.view addSubview:_tabContentView];
    
    _tabArrays = [[NSMutableArray alloc] init];
    
    NSArray *sortArrays = [NSArray arrayWithObjects:@"全部", @"关注", nil];
    
    for (int i = 0; i < sortArrays.count; i++) {
        
        QMZBSortItem *sortView;
        sortView = [[QMZBSortItem alloc] initWithFrame:CGRectMake(ScreenWidth/sortArrays.count * (i), 0, ScreenWidth/sortArrays.count, kTabHeight) andName:sortArrays[i] sortImage:@"sort_asc" state:SortNone];
        
        if (i == 0) {
            sortView.nameLabel.textColor = COLOR(25, 151, 220, 1); // 初始状态
        }
        
        UILabel *linelabel = [[UILabel alloc] init];
        linelabel.backgroundColor = [UIColor lightGrayColor];
        if(i != 1)
        {
            linelabel.frame = CGRectMake(ScreenWidth/sortArrays.count * (i+1), 11, 0.2, kTabHeight-22);
        }
        
        [sortView setTag:i];
        [sortView addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabArrays addObject:sortView];
        [_tabContentView addSubview:sortView];
        [_tabContentView addSubview:linelabel];
    }
    
    _type = TYPE_TAB1;
    
    _tabGrop = [[QMZBSortGroup alloc] initWithFrame:CGRectMake(0, kTabHeight - 3.0, ScreenWidth, 3) sortArrays:_tabArrays defaultPosition:0];
    [_tabContentView addSubview:_tabGrop];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kTabHeight - 0.5f, ScreenWidth, 1.f)];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [_tabContentView addSubview:line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTabHeight , ScreenWidth, ScreenHeight - 64 - kTabHeight-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_DARK_COLOR;
    _tableView.delegate = self;
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    
    _dataArrays = [NSMutableArray array];
    _onlineList = [NSMutableArray array];
    _offlineList = [NSMutableArray array];

    
}

- (void)itemClick:(QMZBSortItem *)sender
{
    
    if (_isLoading) {
        return;
    }
    
    switch (sender.tag) {
        case 0:
        {
            if (_type == TYPE_TAB1) {
                return;
            }
            _type = TYPE_TAB1;
        }
            break;
        case 1:
        {
            if (_type == TYPE_TAB2) {
                return;
            }
            _type = TYPE_TAB2;
        }
            break;
        default:
            break;
    }
    for (QMZBSortItem *sortView in _tabArrays) {
        sortView.nameLabel.textColor = TEXT_BLACK_COLOR;
    }
    sender.nameLabel.textColor = COLOR(25, 151, 220, 1);
    
    _pageIndex = 1;
    [self requestData:_pageIndex];
}

- (void) requestData:(NSInteger) pageindex
{
    if (_isLoading) {
        return;
    }
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:@(_type) forKey:@"type"];
    [parameters setObject:@(pageindex) forKey:@"refresh"];
    [parameters setObject:@(10) forKey:@"count"];
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [_requestClient postddByByUrlPath:@"/live/GetLiveRoomList" andParams:parameters andCallBack:^(id back) {
        [self hiddenRefreshView];
        if ([back isKindOfClass:[NSString class]]) {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
            return ;
        }else {
            NSDictionary *dics = back;
            NSLog(@"%@",dics);
            int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
            if (result_type  == 10000) {
                [HUD hide:YES];
                if (pageindex == 1) {
                    [_dataArrays removeAllObjects];
                    [_onlineList removeAllObjects];
                    [_offlineList removeAllObjects];
                }
                if (_type == 1) {
                    
                    if ([[dics objectForKey:@"list"] isKindOfClass:[NSNull class]]) {
                        
                    }else {
                        
                        NSArray *array = [NSArray array];
                        array = [dics objectForKey:@"list"];
                        for (NSDictionary *dictionary in array) {
                            QMZBLiveListModel *model = [[QMZBLiveListModel alloc] init];
                            model.followCount = [NSString jsonUtils:[dictionary objectForKey:@"followCount"]];
                            model.anchorIcon = [dictionary objectForKey:@"headPicId"];
                            model.anchorName = [dictionary objectForKey:@"anchorName"];
                            model.liveRoomTopic = [dictionary objectForKey:@"liveRoomTopic"];
                            model.liveRoomDesc = [dictionary objectForKey:@"liveRoomDesc"];
                            model.liveRoomName = [dictionary objectForKey:@"liveRoomName"];
                            model.liveRoomUserPwd = [dictionary objectForKey:@"liveRoomUserPwd"];
                            model.liveRoomanchorPwd = [dictionary objectForKey:@"liveRoomAnchorPwd"];
                            model.liveRoomId = [dictionary objectForKey:@"liveRoomId"];
                            model.isFollow = [NSString jsonUtils:[dictionary objectForKey:@"isFollow"]];
                            model.playerCount = [NSString jsonUtils:[dictionary objectForKey:@"playerCount"]];

                            [_dataArrays addObject:model];
                        }
                    }
                }else {
                    
                    if ([[dics objectForKey:@"onlineList"] isKindOfClass:[NSNull class]]) {
                        
                    }else {
                        
                        NSArray *onlineArray = [NSArray array];
                        onlineArray = [dics objectForKey:@"onlineList"];
                        for (NSDictionary *dictionary in onlineArray) {
                            QMZBLiveListModel *model = [[QMZBLiveListModel alloc] init];
                            model.followCount = [NSString jsonUtils:[dictionary objectForKey:@"followCount"]];
                            model.anchorIcon = [dictionary objectForKey:@"headPicId"];
                            model.anchorName = [dictionary objectForKey:@"anchorName"];
                            model.liveRoomTopic = [dictionary objectForKey:@"liveRoomTopic"];
                            model.liveRoomDesc = [dictionary objectForKey:@"liveRoomDesc"];
                            model.liveRoomName = [dictionary objectForKey:@"liveRoomName"];
                            model.liveRoomUserPwd = [dictionary objectForKey:@"liveRoomUserPwd"];
                            model.liveRoomanchorPwd = [dictionary objectForKey:@"liveRoomAnchorPwd"];
                            model.liveRoomId = [dictionary objectForKey:@"liveRoomId"];
                            model.isFollow = [NSString jsonUtils:[dictionary objectForKey:@"isFollow"]];
                            model.playerCount = [NSString jsonUtils:[dictionary objectForKey:@"playerCount"]];

                            [_onlineList addObject:model];
                        }
                    }
                    if ([[dics objectForKey:@"offlineList"] isKindOfClass:[NSNull class]]) {
                        
                    }else {
                        
                        NSArray *offLineArray = [NSArray array];
                        offLineArray = [dics objectForKey:@"offlineList"];
                        for (NSDictionary *dictionary in offLineArray) {
                            QMZBLiveListModel *model = [[QMZBLiveListModel alloc] init];
                            model.followCount = [NSString jsonUtils:[dictionary objectForKey:@"followCount"]];
                            model.anchorIcon = [NSString jsonUtils:[dictionary objectForKey:@"headPicId"]];
                            model.anchorName = [NSString jsonUtils:[dictionary objectForKey:@"anchorName"]];
                            model.liveRoomTopic = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomTopic"]];
                            model.liveRoomDesc = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomDesc"]];
                            model.liveRoomName = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomName"]];
                            model.liveRoomUserPwd = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomUserPwd"]];
                            model.liveRoomanchorPwd = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomAnchorPwd"]];
                            model.liveRoomId = [NSString jsonUtils:[dictionary objectForKey:@"liveRoomId"]];
                            model.isFollow = [NSString jsonUtils:[dictionary objectForKey:@"isFollow"]];
                            model.playerCount = [NSString jsonUtils:[dictionary objectForKey:@"playerCount"]];

                            [_offlineList addObject:model];
                        }
                    }
                    
                }
                [_tableView reloadData];
            }else if (result_type  == 10003) {
                AppDelegateInstance.userInfo.isLogin = NO;
                NSLog(@"++++++++++++");
                [_requestClient reLogin_andCallBack:^(BOOL back) {
                    if (back) {
                        
                        NSLog(@"------------");
                        _isLoading  = NO;
                        [self requestData:1];
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
        }
        _isLoading  = NO;
    }];

}


- (void) followLiveRoom:(NSInteger) liveRoomId :(NSInteger) isFollow
{
    if (_isLoading) {
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:@(liveRoomId) forKey:@"liveRoomId"];
    [parameters setObject:@(isFollow) forKey:@"isFollow"];
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [_requestClient postddByByUrlPath:@"/live/FollowLiveRoom" andParams:parameters andCallBack:^(id back) {
        [self hiddenRefreshView];
        if ([back isKindOfClass:[NSString class]]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [HUD hide:YES];
            return ;
        }else {
            NSDictionary *dics = back;
            NSLog(@"%@",dics);
            int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
            if (result_type  == 10000) {
                [HUD hide:YES];
                
            }else if (result_type  == 10003) {
                AppDelegateInstance.userInfo.isLogin = NO;
                [_requestClient reLogin_andCallBack:^(BOOL back) {
                    if (back) {
                        
                        _isLoading  = NO;
                       [self followLiveRoom: liveRoomId : isFollow];
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
        }
        _isLoading  = NO;
    }];
    
}


- (void)hud:(MBProgressHUD *)hud showError:(NSString *)error
{
    hud.detailsLabelText = error;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}


#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 分组的数量
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 一个组的item的数量
    if (_type == TYPE_TAB1) {
        
        return _dataArrays.count;
    }
    return (_onlineList.count + _offlineList.count);

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    QMZBLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil) {
        cell = [[QMZBLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCell];
    }
    cell.backgroundColor = BACKGROUND_COLOR;
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_type == TYPE_TAB1) {
        
        QMZBLiveListModel *obj = [[QMZBLiveListModel alloc]init];
        obj = _dataArrays[indexPath.row];
        cell.isOnlive.image = [UIImage imageNamed:@"zhibozhong"];
        [cell fillCellWithObject:obj];
    }else {
        if (_onlineList.count == 0) {
            QMZBLiveListModel *obj = [[QMZBLiveListModel alloc]init];
            obj = _offlineList[indexPath.row];
            cell.isOnlive.image = [UIImage imageNamed:@"yijieshu"];

            [cell fillCellWithObject:obj];
        }else {
            
            if (indexPath.row < _onlineList.count) {
                QMZBLiveListModel *obj = [[QMZBLiveListModel alloc]init];
                obj = _onlineList[indexPath.row];
                cell.isOnlive.image = [UIImage imageNamed:@"zhibozhong"];
                [cell fillCellWithObject:obj];
            }else {
                QMZBLiveListModel *obj = [[QMZBLiveListModel alloc]init];
                obj = _offlineList[indexPath.row - _onlineList.count];
                cell.isOnlive.image = [UIImage imageNamed:@"yijieshu"];

                [cell fillCellWithObject:obj];
            }
        }
    }
    __block QMZBLiveCell *blockCell = cell;
    cell.didSelectedButton = ^(UIButton *button){
        QMZBLiveListModel *model = [[QMZBLiveListModel alloc]init];
        if (_type == TYPE_TAB1) {
            
            model = _dataArrays[indexPath.row];
            if ([model.isFollow integerValue] == 0) {
                
                [self followLiveRoom:[model.liveRoomId integerValue] :1];
                model.isFollow = @"1";
                [blockCell.followButton setTitle:@"已关注" forState:UIControlStateNormal];
                [blockCell.followButton setImage:[UIImage imageNamed:@"icon_follow_yes"] forState:UIControlStateNormal];
            }else {
                [self followLiveRoom:[model.liveRoomId integerValue] :0];
                model.isFollow = @"0";
                [blockCell.followButton setTitle:@"未关注" forState:UIControlStateNormal];
                [blockCell.followButton setImage:[UIImage imageNamed:@"icon_follow_no"] forState:UIControlStateNormal];
            }
            [_dataArrays removeObjectAtIndex:indexPath.row];
            [_dataArrays insertObject:model atIndex:indexPath.row];
        }else {
            if (_onlineList.count == 0) {
                model = _offlineList[indexPath.row - _onlineList.count];
                
                [self followLiveRoom:[model.liveRoomId integerValue] :0];
                
                [_offlineList removeObjectAtIndex:(indexPath.row - _onlineList.count)];
            }else {
                
                if (indexPath.row < _onlineList.count) {
                    model = _onlineList[indexPath.row];
                    
                    [self followLiveRoom:[model.liveRoomId integerValue] :0];
                    
                    [_onlineList removeObjectAtIndex:indexPath.row];
                }else {
                    model = _offlineList[indexPath.row - _onlineList.count];
                    
                    [self followLiveRoom:[model.liveRoomId integerValue] :0];
                    
                    [_offlineList removeObjectAtIndex:(indexPath.row - _onlineList.count)];
                }
            }
        }
        [_tableView reloadData];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格被点击的监听
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QMZBLiveListModel *obj = [[QMZBLiveListModel alloc]init];
    
    if (_type == TYPE_TAB1) {
        
        obj = _dataArrays[indexPath.row];
    }else {
        if (_onlineList.count == 0) {
            obj = _offlineList[indexPath.row-_onlineList.count];
        }else {
            
            if (indexPath.row < _onlineList.count) {
                
                obj = _onlineList[indexPath.row];
            }else {
                
                obj = _offlineList[indexPath.row-_onlineList.count];
            }
        }
    }
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    QMZBChatViewController *loginController = [story instantiateViewControllerWithIdentifier:@"chatView"];
    loginController.isLiveMode = 0;
    loginController.roomId = obj.liveRoomId;
    loginController.password = obj.liveRoomUserPwd;
    loginController.nickName = AppDelegateInstance.userInfo.nickName;
    [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    AppDelegateInstance.allowRotation = YES;

    [self presentViewController:loginController animated:YES completion:nil];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _pageIndex = 1;
    [self requestData:_pageIndex];
    
}

- (void)footerRereshing
{
    _pageIndex = 0;
    [self requestData:_pageIndex];
}



// 隐藏刷新视图
-(void) hiddenRefreshView
{
    if (!self.tableView.isHeaderHidden) {
        [self.tableView headerEndRefreshing];
    }
    
    if (!self.tableView.isFooterHidden) {
        [self.tableView footerEndRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
