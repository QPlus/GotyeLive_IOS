//
//  AppDelegate.h
//  QMZB
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMZBUserInfo.h"

@interface QMZBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) UIViewController *viewController;

@property(nonatomic, strong) QMZBUserInfo* userInfo;

@property (assign, nonatomic) BOOL allowRotation;

@end

