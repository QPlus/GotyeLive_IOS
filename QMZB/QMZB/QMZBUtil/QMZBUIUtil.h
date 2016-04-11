//
//  QMZBUIUtil.h
//  QuanMingZhiBo
//
//  Created by Jim on 16/3/16.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMZBAppDelegate.h"

//设置RGB颜色值
#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

// app 背景色
#define BACKGROUND_COLOR	COLOR(255,255,255,1)

// app 深灰背景色
#define BACKGROUND_DARK_COLOR	COLOR(240,239,237,1)

// app 橘黄色
#define ORANGE_COLOR	COLOR(216,80,92,1)

// app 蓝色
#define BLUE_COLOR	 COLOR(53,146,226,1)

// 字体黑色 #ff505050
#define TEXT_BLACK_COLOR	COLOR(80,80,80,1)

// 字体灰色 #ffe9e9e9
#define TEXT_DARK_COLOR	COLOR(158,158,158,1)

// 字体红色
#define TEXT_RED_COLOR	COLOR(255,0,0,1)

//字体暗红色
#define TEXT_DARKRED_COLOR COLOR(208,57,83,1)

// 白色
#define WHITE_COLOR	[UIColor whiteColor]

// 黑色
#define BLACK_COLOR	[UIColor blackColor]

// 灰色
#define DARK_COLOR	  COLOR(158,158,158,1)

// 分割线颜色
#define DIVIDE_LINE_COLOR  COLOR(182,182,182,1)


#define Common_Color_Def_Nav    [UIColor colorWithRed:((float)((0x0fd5c9 & 0xFF0000) >> 16))/255.0 green:((float)((0x0fd5c9 & 0xFF00) >> 8))/255.0 blue:((float)(0x0fd5c9 & 0xFF))/255.0 alpha:(1)]
#define Common_Color_Def_Gray   [UIColor colorWithRed:((float)((0xeeeeee & 0xFF0000) >> 16))/255.0 green:((float)((0xeeeeee & 0xFF00) >> 8))/255.0 blue:((float)(0xeeeeee & 0xFF))/255.0 alpha:(1)]

#define ScreenHeight    ([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth     ([[UIScreen mainScreen] bounds].size.width)

#define NotificationUpdateTab @"update_tab"
#define NotificationchangeUserInfo @"changeUserInfo"
#define NotificationloginSeccess @"loginSeccess"
#define NotificationCreateLiveRoom @"CreateLiveRoom"
#define NotificationLevelRoom @"userLevelRoom"

// 应用程序总代理
#define AppDelegateInstance	     ((QMZBAppDelegate*)([UIApplication sharedApplication].delegate))


@interface QMZBUIUtil : NSObject

@end
