//
//  QMZBSettingController.m
//  QuanMingZhiBo
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBSettingController.h"
#import "QMZBUIUtil.h"
#import "QMZBContactController.h"
#import "QMZBMySettingController.h"
#import "QMZBRegisterChannelController.h"
#import "QMZBUserInfo.h"
#import "QMZBNetwork.h"
#import "MBProgressHUD.h"
#import "NSString+Extension.h"
#import "QMZBModifyLiveRoomController.h"

@interface QMZBSettingController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_myHeadImage;
    UILabel *_userNameLabel;
    UILabel *_channelLabel;
    UIButton *_nickNameButton;
    UILabel *_nickNameLabel;

    BOOL _isLoading;
    MBProgressHUD *HUD;
    
    NSString *_nickName;
    
    UITableView *_tableView;
}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = WHITE_COLOR;
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 0)];

    
    

    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:NotificationCreateLiveRoom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSeccessNotification:) name:NotificationloginSeccess object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateSelected:) name:NotificationUpdateTab object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo:) name:NotificationchangeUserInfo object:nil];


}

- (void)notification:(NSNotification *)notification
{
    NSString *chan = [NSString stringWithFormat:@"直播账号: %@",AppDelegateInstance.userInfo.liveRoomId];
    if ([AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
        chan = @"直播账号: 无";
    }
    _channelLabel.text = chan;
    
}


- (void)changeUserInfo:(NSNotification *)notification
{
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
    [_myHeadImage setBackgroundImage:img forState:UIControlStateNormal];
    _nickNameLabel.text = [NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.nickName];
    _userNameLabel.text = [NSString stringWithFormat:@"用户账号: %@",AppDelegateInstance.userInfo.userName];

}

- (void)loginSeccessNotification:(NSNotification *)notification
{
    if ([AppDelegateInstance.userInfo.headerpicId isEqualToString:@"0"]) {
        
    }else {
        
        [self getUserPic];
    }
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tabBarController.navigationItem.titleView removeFromSuperview];
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 0)];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

}

-(void) updateSelected:(NSNotification *)notification
{
    NSString *itemIndex = (NSString *)[notification object];
    
    if ([itemIndex isEqualToString:@"102"]) {
        [self.tabBarController.navigationItem.titleView removeFromSuperview];
        [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 0)];
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
    }else {
        
    }
    
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
- (void)initView
{
//    _myHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 80, 60, 60)];
//    _myHeadImage.image = [UIImage imageNamed:@"watermark"];
    UIView *headerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    [self.view addSubview:headerBackground];
    
    UIImageView *header_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    header_bg.image = [UIImage imageNamed:@"header_bg"];
    [headerBackground addSubview:header_bg];
    
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
    if (img) {
        
    }else {
        
        img = [UIImage imageNamed:@"user_default_head"];
    }
    if ([AppDelegateInstance.userInfo.headerpicId isEqualToString:@"0"]) {
        img = [UIImage imageNamed:@"user_default_head"];
        [self saveImage:img withName:@"currentImage.png"];

    }else {
        
    }
    _myHeadImage = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2-35, 50, 70, 70)];
    _myHeadImage.tag = 201;
    [_myHeadImage setBackgroundImage:img forState:UIControlStateNormal];
    _myHeadImage.layer.masksToBounds = YES;
    _myHeadImage.layer.cornerRadius = _myHeadImage.bounds.size.width*0.5;
    _myHeadImage.layer.borderWidth = 2.0;
    _myHeadImage.layer.borderColor = [UIColor clearColor].CGColor;
    [_myHeadImage addTarget:self action:@selector(singleClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerBackground addSubview:_myHeadImage];
    
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_myHeadImage.frame)+10, ScreenWidth/2+20, 20)];
    _nickNameLabel.text = [NSString stringWithFormat:@"%@",AppDelegateInstance.userInfo.nickName];
    _nickNameLabel.font = [UIFont systemFontOfSize:18];
    _nickNameLabel.backgroundColor = [UIColor clearColor];
    _nickNameLabel.textAlignment = NSTextAlignmentRight;
    _nickNameLabel.textColor = WHITE_COLOR;
    [headerBackground addSubview:_nickNameLabel];
    
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nickNameLabel.frame)+5, ScreenWidth-20, 20)];
    _userNameLabel.text = [NSString stringWithFormat:@"用户账号: %@",AppDelegateInstance.userInfo.userName];
    _userNameLabel.font = [UIFont systemFontOfSize:13];
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.textColor = WHITE_COLOR;
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    [headerBackground addSubview:_userNameLabel];
    
    
    _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_userNameLabel.frame)+5, ScreenWidth-20, 20)];
    NSString *chan = [NSString stringWithFormat:@"直播账号: %@",AppDelegateInstance.userInfo.liveRoomId];
    if ([AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
        chan = @"直播账号: 无";
    }
    _channelLabel.text = chan;
    _channelLabel.textAlignment = NSTextAlignmentCenter;
    _channelLabel.font = [UIFont systemFontOfSize:13];
    _channelLabel.backgroundColor = [UIColor clearColor];
    _channelLabel.textColor = WHITE_COLOR;
    [headerBackground addSubview:_channelLabel];
    
    
    _nickNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nickNameButton.frame = CGRectMake(ScreenWidth/2+55, CGRectGetMaxY(_myHeadImage.frame)-5, 40, 40);
    _nickNameButton.backgroundColor = [UIColor clearColor];
    [_nickNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_nickNameButton setImage:[UIImage imageNamed:@"change_nickName"] forState:UIControlStateNormal];
    _nickNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerBackground addSubview:_nickNameButton];
    _nickNameButton.tag = 202;
    [_nickNameButton addTarget:self action:@selector(singleClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headerBackground.frame) , ScreenWidth-20, 150) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_DARK_COLOR;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (void)getUserPic
{
    
//    [_myHeadImage setBackgroundImage:[UIImage imageNamed:@"watermark"] forState:UIControlStateNormal];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/live/GetUserHeadPic?id=%@",BaseServiceUrl,AppDelegateInstance.userInfo.headerpicId]];

    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    [_myHeadImage setBackgroundImage:result forState:UIControlStateNormal];
    
}


- (void)singleClick:(UIButton *)gesture
{
    if (gesture.tag == 201) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开照相机" otherButtonTitles:@"从手机相册获取", nil];
        [actionSheet showInView:self.view];
    }else {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"昵称" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
    
    
}

- (void)requestModifyUserNickName
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:_nickName forKey:@"nickName"];
    
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/ModifyUserInfo" andParams:parameters andCallBack:^(id back) {
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
            AppDelegateInstance.userInfo.nickName = _nickName;
            _nickNameLabel.text=_nickName ;

            NSLog(@"%@", dics);
            HUD.mode = MBProgressHUDModeIndeterminate;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = @"修改成功";
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    _isLoading  = NO;
                    [self requestModifyUserNickName];
                }
            }];
            
        }else {
            // 错误返回码
            NSString *msg = [dics objectForKey:@"desc"];
            NSLog(@"未返回正确的数据：%@", msg);
            HUD.mode = MBProgressHUDModeIndeterminate;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = msg;
        }
        _isLoading  = NO;
    }];

}

- (void)requestModifyUserHeadPic:(NSString *)imageString
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:imageString forKey:@"headPic"];
    
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [self startRequest];
    [_requestClient postddByByUrlPath:@"/live/ModifyUserHeadPic" andParams:parameters andCallBack:^(id back) {
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
            AppDelegateInstance.userInfo.headerpicId = [NSString jsonUtils:[dics objectForKey:@"headPicId"]];
            HUD.mode = MBProgressHUDModeIndeterminate;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = @"修改成功";
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    _isLoading  = NO;
                    [self requestModifyUserHeadPic:imageString];
                }
            }];
            
        }else {
            // 错误返回码
            NSString *msg = [dics objectForKey:@"desc"];
            NSLog(@"未返回正确的数据：%@", msg);
            HUD.mode = MBProgressHUDModeIndeterminate;
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf=[alertView textFieldAtIndex:0];
    if (tf.text.length == 0) {
        return;
    }
    _nickName = tf.text;
//    _nickNameLabel.text=_nickName ;
    [self requestModifyUserNickName];
    NSLog(@"=====%@",tf.text);
}



#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            //打开照相机拍照
            [self takePhoto];
            
        }
            break;
        case 1:
        {
            //打开本地相册
            [self LocalPhoto];
        }
            break;
    }
}

//点击 相机 照相
- (void) takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"相机不可用");
        return;
    }
    
    
    UIImagePickerController *ctl = [[UIImagePickerController alloc] init];
    ctl.delegate = self;
    //源
    ctl.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    //类型
    //    ctl.mediaTypes = @[(NSString *)kUTTypeImage];
    ctl.allowsEditing = YES;
    [self presentViewController:ctl animated:YES completion:^{
    }];
    
}

//点击 相册 从相册中选择图片
- (void) LocalPhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"相册不可用");
        return;
    }
    
    UIImagePickerController *ctl = [[UIImagePickerController alloc] init];
    ctl.delegate = self;
    //源
    ctl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    //类型
    //    ctl.mediaTypes = @[(NSString *)kUTTypeImage];
    ctl.allowsEditing = YES;
    [self presentViewController:ctl animated:YES completion:^{
    }];
    
    
}

#pragma mark - UIImagePickerControllerDelegate,UINavigationControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    UIImage *img = [self imageWithImage:savedImage scaledToSize:CGSizeMake(100, 100)];
    NSString *_encodedImageStr = [UIImageJPEGRepresentation(img,0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];;
    
    NSLog(@"%@",_encodedImageStr);
    [self requestModifyUserHeadPic:_encodedImageStr];
    [_myHeadImage setBackgroundImage:img forState:UIControlStateNormal];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
//压缩图片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


//当用户点击系统相册的取消时调用
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    return 3;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //每个单元格的视图
    static NSString *itemCell = @"cell_item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCell];
    }
    cell.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_icon_%ld",(long)indexPath.row]];
    [cell addSubview:image];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 100, 30)];
    text.font = [UIFont systemFontOfSize:13.0];
    text.textColor = TEXT_BLACK_COLOR;
    [cell addSubview:text];
    
    if (indexPath.row == 0) {
         text.text = @"直播账号";
    }else if (indexPath.row == 1) {
         text.text = @"个人设置";
    }else if (indexPath.row == 2) {
         text.text = @"联系亲加";
    }else {
        
    }
    
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40, 15, 10, 14)];
    arrow.image = [UIImage imageNamed:[NSString stringWithFormat:@"jiaotou_image"]];
    [cell addSubview:arrow];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格被点击的监听
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (![AppDelegateInstance.userInfo.liveRoomId isEqualToString:@"0"]) {
            
            QMZBModifyLiveRoomController *channel = [[QMZBModifyLiveRoomController alloc] init];
            UINavigationController *channelNavigation = [[UINavigationController alloc] initWithRootViewController:channel];
            [channel setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//            [self.navigationController pushViewController:channel animated:YES];

            [self presentViewController:channelNavigation animated:YES completion:nil];
        }else {
            
            QMZBRegisterChannelController *channel = [[QMZBRegisterChannelController alloc] init];
            UINavigationController *channelNavigation = [[UINavigationController alloc] initWithRootViewController:channel];
            [channel setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//            [self.navigationController pushViewController:channel animated:YES];

            [self presentViewController:channelNavigation animated:YES completion:nil];
        }
    }else if (indexPath.row == 1) {
        QMZBMySettingController *mySetting = [[QMZBMySettingController alloc] init];
        UINavigationController *mySettingNavigation = [[UINavigationController alloc] initWithRootViewController:mySetting];
        [mySetting setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        [self.navigationController pushViewController:mySetting animated:YES];
        [self presentViewController:mySettingNavigation animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        QMZBContactController *contact = [[QMZBContactController alloc] init];
        [contact setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        [self.navigationController pushViewController:contact animated:YES];

        UINavigationController *contactNavigation = [[UINavigationController alloc] initWithRootViewController:contact];
        [self presentViewController:contactNavigation animated:YES completion:nil];
    }else {
        
    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


@end

