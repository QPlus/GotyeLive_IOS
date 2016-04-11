//
//  QMZBRegisterChannelController.h
//  QMZB
//
//  Created by Jim on 16/3/22.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMZBRegisterChannelController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *liveName;
@property (strong, nonatomic) IBOutlet UITextView *introduceText;
@property (nonatomic, assign) NSInteger itemTag;//标记是从哪个页面进入直播页面的

@end
