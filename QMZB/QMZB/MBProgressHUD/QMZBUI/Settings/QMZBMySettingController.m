//
//  QMZBMySettingController.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBMySettingController.h"
#import "QMZBUIUtil.h"
#import "QMZBLoginController.h"
#import "QMZBUserInfo.h"
#import "QMZBNetwork.h"
#import "NSString+Extension.h"
#import "MBProgressHUD.h"

@interface QMZBMySettingController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITableView *_tableView;
    MBProgressHUD *HUD;
    NSString *_nickName;
    NSInteger _sex;

}

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBMySettingController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self initNavigationBar];
    
    [self initView];
}
// 初始化导航条
- (void)initNavigationBar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent =NO;
    self.title = @"设置";
    self.view.backgroundColor = BACKGROUND_DARK_COLOR;
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    backItem.tintColor = WHITE_COLOR;
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    _nickName = AppDelegateInstance.userInfo.nickName;
    _sex = [AppDelegateInstance.userInfo.sex integerValue];
}

// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self dismissViewControllerAnimated:YES completion:^(){}];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationchangeUserInfo object:nil];
        }
            break;
    }
}

- (void)initView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 , ScreenWidth, 310) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;

    [self.view addSubview:_tableView];
    
}

- (void)requestModifyUserNickName
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:_nickName forKey:@"nickName"];
    [parameters setObject:@(_sex) forKey:@"sex"];

    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [_requestClient postddByByUrlPath:@"/live/ModifyUserInfo" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSDictionary *dics = back;
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            [HUD hide:YES];
            AppDelegateInstance.userInfo.nickName = _nickName;
            AppDelegateInstance.userInfo.sex = [NSString stringWithFormat:@"%ld",(long)_sex];

            NSLog(@"%@", dics);
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeIndeterminate;
            [HUD hide:YES afterDelay:2]; // 延时2s消失
            HUD.labelText = @"修改成功";
            [_tableView reloadData];
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                   
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
    }];
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf=[alertView textFieldAtIndex:0];
    if (tf.text.length == 0) {
        return;
    }
    _nickName = tf.text;
    [self requestModifyUserNickName];
    NSLog(@"=====%@",tf.text);
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1111) {
        
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
    }else if (actionSheet.tag == 2222) {
        switch (buttonIndex)
        {
            case 0:
            {
                _sex = 1;
                [self requestModifyUserNickName];
                
            }
                break;
            case 1:
            {
                _sex = 2;
                [self requestModifyUserNickName];

            }
                break;
        }
    }else {
        
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
    
//    NSLog(@"%@",_encodedImageStr);
    [self requestModifyUserHeadPic:_encodedImageStr];
    [_tableView reloadData];
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


#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 分组的数量
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 一个组的item的数量
    if (section == 0) {
        return 4;
    }else if (section == 1) {
        
        return 1;
    }else {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 分组的间隔线底部高度
    return 5;
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
    
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 10005) {
            [view removeFromSuperview];
        }
    }
    UIView *cellView = [[UIView alloc] initWithFrame:cell.bounds];
    cellView.tag = 10005;
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    text.font = [UIFont systemFontOfSize:13.0];
    text.textColor = TEXT_BLACK_COLOR;
    text.tag = 10001;
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-130, 10, 100, 30)];
    detail.textAlignment = NSTextAlignmentRight;
    detail.font = [UIFont systemFontOfSize:13.0];
    detail.textColor = TEXT_BLACK_COLOR;
    detail.tag = 10002;
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            text.text = @"头像";
            
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
            UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
            if (img) {
                
            }else {
                
                img = [UIImage imageNamed:@"user_default_head"];
            }
            if ([AppDelegateInstance.userInfo.headerpicId isEqualToString:@"0"]) {
                img = [UIImage imageNamed:@"user_default_head"];
            }
            UIImageView *myHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-70, 5, 40, 40)];
            myHeadImage.tag = 10003;
            myHeadImage.image = img;
            myHeadImage.layer.masksToBounds = YES;
            myHeadImage.layer.cornerRadius = myHeadImage.bounds.size.width*0.5;
            myHeadImage.layer.borderWidth = 2.0;
            myHeadImage.layer.borderColor = [UIColor clearColor].CGColor;
            [cellView addSubview:myHeadImage];
            

        }else if (indexPath.row == 1) {
            text.text = @"昵称";
            detail.text = AppDelegateInstance.userInfo.nickName;
            [cellView addSubview:detail];
        }else if (indexPath.row == 2) {
            text.text = @"用户账号";
            detail.text = AppDelegateInstance.userInfo.userName;
            [cellView addSubview:detail];
        }else if (indexPath.row == 3){
            text.text = @"直播账号";
            detail.text = AppDelegateInstance.userInfo.liveRoomId;
            [cellView addSubview:detail];
        }else {
            
        }
        [cellView addSubview:text];
    }else if (indexPath.section == 1) {
        if ([AppDelegateInstance.userInfo.sex isEqualToString:@"1"]) {
            detail.text = @"男";

        }else {
            
            detail.text = @"女";
        }
        text.text = @"性别";
        [cellView addSubview:detail];
        [cellView addSubview:text];
    }else {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 30)];
        text.font = [UIFont systemFontOfSize:14.0];
        text.textColor = COLOR(25, 151, 220, 1);
        text.textAlignment = NSTextAlignmentCenter;
        text.text = @"退出";
        text.tag = 10004;
        [cellView addSubview:text];

    }
    
    [cell.contentView addSubview:cellView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格被点击的监听
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"昵称" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
//    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [alert show];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开照相机" otherButtonTitles:@"从手机相册获取", nil];
            actionSheet.tag = 1111;
            [actionSheet showInView:self.view];
            
        }else if (indexPath.row == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"昵称" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert show];
        }else if (indexPath.row == 2) {
            
        }else if (indexPath.row == 3){
            
        }else {
            
        }
    }else if (indexPath.section == 1) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"性别" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
//        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        [alert show];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
        actionSheet.tag = 2222;
        [actionSheet showInView:self.view];
        
    }else {
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"100"]];
        [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationLevelRoom object:nil];

        [self dismissViewControllerAnimated:NO completion:^(){}];
//        [self.navigationController popToRootViewControllerAnimated:YES];

        QMZBUserInfo *userInfo = [[QMZBUserInfo alloc] init];
        [userInfo userLogout];
        AppDelegateInstance.userInfo = userInfo;
        AppDelegateInstance.userInfo.isLogin = NO;
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        QMZBLoginController *loginController = [[QMZBLoginController alloc] init];
//        [loginController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        
//        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginController];
//        [self presentViewController:navigation animated:NO completion:nil];
    }
    
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
