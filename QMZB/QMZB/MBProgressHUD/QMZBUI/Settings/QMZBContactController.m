//
//  QMZBContactController.m
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBContactController.h"
#import "QMZBUIUtil.h"

@interface QMZBContactController ()

@end

@implementation QMZBContactController

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
    self.title = @"联系我们";
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self.navigationController.navigationBar setBarTintColor:COLOR(25, 151, 220, 1)];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, nil]];
    
    // 导航条 左边 返回按钮
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ab_ic_back"] style:UIBarButtonItemStyleDone target:self action:@selector(btnClick:)];
    backItem.tintColor = WHITE_COLOR;
    backItem.tag = 1;
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth-20, 30)];
    line.text = @"亲加官网 : http://www.gotye.com.cn";
    line.font = [UIFont systemFontOfSize:18];
    line.backgroundColor = [UIColor clearColor];
    line.textAlignment = NSTextAlignmentCenter;
    line.textColor = TEXT_BLACK_COLOR;
    [self.view addSubview:line];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, ScreenWidth-20, 30)];
    content.text = @"联系方式  : 400-820-2732";
    content.font = [UIFont systemFontOfSize:18];
    content.backgroundColor = [UIColor clearColor];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = TEXT_BLACK_COLOR;
    [self.view addSubview:content];
    
    UILabel *group = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, ScreenWidth-20, 30)];
    group.text = @"技术交流群 : 544476772";
    group.font = [UIFont systemFontOfSize:18];
    group.backgroundColor = [UIColor clearColor];
    group.textAlignment = NSTextAlignmentCenter;
    group.textColor = TEXT_BLACK_COLOR;
    [self.view addSubview:group];
}

// 导航栏点击事件
- (void)btnClick:(UIButton *)sender
{

//    [self.navigationController popToRootViewControllerAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:^(){}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
