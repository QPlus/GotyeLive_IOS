//
//  ChatView.h
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/12.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatConfig;
@class ChatCell;

@interface ChatView : UIView

@property (nonatomic, strong) ChatConfig * config;

- (instancetype)initWithFrame:(CGRect)frame config:(ChatConfig *)config;

- (void)addCell:(ChatCell *)cell;
- (void)addCellWithName:(NSString *)name comment:(NSString *)comment;
- (void)clear;

@end
