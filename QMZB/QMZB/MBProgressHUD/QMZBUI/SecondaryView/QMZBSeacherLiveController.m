//
//  QMZBSeacherLiveController.m
//  QMZB
//
//  Created by Jim on 16/4/7.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBSeacherLiveController.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "QMZBUserInfo.h"
#import "QMZBUIUtil.h"
#import "NSString+Extension.h"
#import "QMZBLiveCell.h"
#import "QMZBLiveListModel.h"
#import "QMZBChatViewController.h"
#import "MJRefresh.h"    //刷新

@interface QMZBSeacherLiveController ()<UISearchBarDelegate,MBProgressHUDDelegate,UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isLoading;
    MBProgressHUD *HUD;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UILabel *searchRecordEmptyLabel;// 无搜索历史的标签

@property (nonatomic, strong) UIView *secondView;

@property (nonatomic, strong) UITableView *tableView; //搜索结果

@property (nonatomic, strong) NSMutableArray *searchArrays;// 搜索记录

@end

@implementation QMZBSeacherLiveController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
    
    [self initSearchResult];
}

- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent =NO;
    
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 1)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    //使用UISearchBar     UISearchBarDelegate,UISearchDisplayDelegate
    _searchBar =[[UISearchBar alloc]init];
    //设置bar的frame
    _searchBar.frame=CGRectMake(0, 0, ScreenWidth - 150, 30);
    _searchBar.showsScopeBar = NO;
    
    UIImage *img = [UIImage imageNamed:@"ab_bg_search"];
    img = [img stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    _searchBar.backgroundImage = img;
    _searchBar.tintColor = TEXT_DARK_COLOR;
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.placeholder = @"搜索直播室";
    
    [headerView addSubview:_searchBar];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    backItem.tintColor = WHITE_COLOR;
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    // 导航条
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    rightItem.tintColor = WHITE_COLOR;
    rightItem.tag = 2;
    
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.navigationItem.titleView = headerView;
}

#pragma mark 点击事件
// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 2:
        {
            // 搜索
            if (![_searchBar.text isBlank]) {
                
                [self requestSearch:_searchBar.text];
                
            }
            [_searchBar resignFirstResponder];
        }
            break;
    }
}

-(void) initSearchResult
{
    _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _secondView.backgroundColor = BACKGROUND_COLOR;
    
    [self.view addSubview:_secondView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:BACKGROUND_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_secondView addSubview:_tableView];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 自动刷新(一进入程序就下拉刷新)
    //    [self.tableView headerBeginRefreshing];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    _searchRecordEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    _searchRecordEmptyLabel.text = @"未搜索到相关直播";
    _searchRecordEmptyLabel.textColor = TEXT_DARK_COLOR;
    _searchRecordEmptyLabel.textAlignment = NSTextAlignmentCenter;
    _searchRecordEmptyLabel.font = [UIFont systemFontOfSize:18.f];
    _searchRecordEmptyLabel.hidden = YES;
    [_secondView addSubview:_searchRecordEmptyLabel];
    
    _searchArrays = [NSMutableArray array];
}

-(void) requestSearch:(NSString *) keyValue
{
    if ([keyValue isBlank]) {
        return;
    }
    
    if (!_isLoading) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
        [parameters setObject:keyValue forKey:@"keyword"];
        
        if (_requestClient == nil) {
            _requestClient = [[QMZBNetwork alloc] init];
        }
        [self startRequest];
        [_requestClient postddByByUrlPath:@"/live/SearchLiveRoom" andParams:parameters andCallBack:^(id back) {
            if ([back isKindOfClass:[NSString class]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [HUD hide:YES];
                return;
            }
            NSDictionary *dics = back;
            NSLog(@"%@",dics);
            int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
            if (result_type == 10000) {
                [HUD hide:YES];
//                if ([[dics objectForKey:@"list"] isKindOfClass:[NSNull class]]) {
//                    
//                }else {
                
                    [_searchArrays removeAllObjects];
                    
//                    NSArray *array = [NSArray array];
//                    array = [dics objectForKey:@"list"];
//                    for (NSDictionary *dictionary in array) {
                        QMZBLiveListModel *model = [[QMZBLiveListModel alloc] init];
                        model.followCount = [NSString jsonUtils:[dics objectForKey:@"followCount"]];
                        model.anchorIcon = [dics objectForKey:@"headPicId"];
                        model.anchorName = [dics objectForKey:@"anchorName"];
                        model.liveRoomTopic = [dics objectForKey:@"liveRoomTopic"];
                        model.liveRoomDesc = [dics objectForKey:@"liveRoomDesc"];
                        model.liveRoomName = [dics objectForKey:@"liveRoomName"];
                        model.liveRoomUserPwd = [dics objectForKey:@"liveRoomUserPwd"];
                        model.liveRoomanchorPwd = [dics objectForKey:@"liveRoomAnchorPwd"];
                        model.liveRoomId = [dics objectForKey:@"liveRoomId"];
                        model.isFollow = [NSString jsonUtils:[dics objectForKey:@"isFollow"]];
                        model.playerCount = [NSString jsonUtils:[dics objectForKey:@"playerCount"]];
                        model.isplay = [NSString jsonUtils:[dics objectForKey:@"isPlay"]];

                        [_searchArrays addObject:model];
//                    }
//                }
                
                if (_searchArrays.count > 0) {
                    _searchRecordEmptyLabel.hidden = YES;
                } else {
                    _searchRecordEmptyLabel.hidden = NO;
                }
                [_tableView reloadData];

            }else if (result_type  == 10003) {
                AppDelegateInstance.userInfo.isLogin = NO;
                [_requestClient reLogin_andCallBack:^(BOOL back) {
                    if (back) {
                        
                        _isLoading  = NO;
                        [self requestSearch:keyValue];
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
    return _searchArrays.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 分组的间隔线头部高度
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 分组的间隔线底部高度
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格的高度
    return 100;
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    QMZBLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil) {
        cell = [[QMZBLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCell];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    QMZBLiveListModel *obj = _searchArrays[indexPath.row];
    
    [cell fillCellWithObject:obj];
    if ([obj.isplay isEqualToString:@"0"]) {
        cell.isOnlive.image = [UIImage imageNamed:@"yijieshu"];
    }else {
        cell.isOnlive.image = [UIImage imageNamed:@"zhibozhong"];
    }
    __block QMZBLiveCell *blockCell = cell;
    cell.didSelectedButton = ^(UIButton *button){
        QMZBLiveListModel *model = [[QMZBLiveListModel alloc]init];
        
            model = _searchArrays[indexPath.row];
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
        
        [_tableView reloadData];
    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格被点击的监听
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QMZBLiveListModel *obj = _searchArrays[indexPath.row];
    
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

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self hiddenRefreshView];
//    [self requestSearch:_pageIndex];
}

- (void)footerRereshing
{
    [self hiddenRefreshView];
//    [self requestData:_pageIndex];
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

-(void) startRequest
{
    _isLoading = YES;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载...";
    HUD.delegate = self;
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    [self requestSearch:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self requestSearch:searchBar.text];
    [_searchBar resignFirstResponder];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
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
