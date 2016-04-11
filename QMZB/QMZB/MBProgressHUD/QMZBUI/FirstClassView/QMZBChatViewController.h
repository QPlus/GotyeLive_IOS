//
//  ChatViewController.h
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/11.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMZBChatViewController : UIViewController

@property (nonatomic, assign) BOOL isLiveMode;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) NSInteger itemTag;//标记是从哪个页面进入直播页面的
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickName;

@end
