//
//  QMZBNetwork.m
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBNetwork.h"
#import "QMZBUserInfo.h"
#import "NSString+Extension.h"
#import "QMZBUIUtil.h"


@implementation QMZBNetwork

//ios自带的post请求方式
-(void)postddByByUrlPath:(NSString *)path andParams:(NSDictionary*)params andCallBack:(void(^)(id back))callback
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseServiceUrl,path]];
    NSLog(@"%@",url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
//    NSString *str = [NSString stringWithFormat:@"data=%@&userId=%@&flag=1&fileType=jpg",img,AppDelegateInstance.userInfo.userId];//设置参数
    
    NSData *data = [[self dictionaryToJson:params ] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    //    NSLog(@"-------%@",str1);
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            callback(dict);
        }else {
            NSLog(@"%@",connectionError);
            NSString *connecterror = @"网络连接失败";
            callback(connecterror);
        }
    }];
}

-(void)getddByByUrlPath:(NSString *)path andParams:(NSString *)params andCallBack:(void(^)(id back))callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",BaseServiceUrl,path,params]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            callback(dict);
        }else {
            callback(connectionError);
        }
    }];

}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)reLogin_andCallBack:(void(^)(BOOL back))callback//判断session Id过期
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"account"] forKey:@"account"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"] forKey:@"password"];
   
    [self postddByByUrlPath:@"/live/Login" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            callback(NO);
            return ;
        }
        NSDictionary *dics = back;
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
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
            callback(YES);
        }else {
            callback(NO);
        }
        
    }];
    
}
@end
