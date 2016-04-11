//
//  ChatCell.h
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/12.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChatConfig;

@interface ChatCell : UIView

@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *commentLabel;
@property (nonatomic, strong) ChatConfig    *config;

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment config:(ChatConfig *)config;
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment;

@end


@class ChatLayout;

@interface ChatConfig : NSObject
@property (nonatomic, strong) UIFont        *nameFont;
@property (nonatomic, strong) UIColor       *nameColor;
@property (nonatomic, strong) UIFont        *commentFont;
@property (nonatomic, strong) UIColor       *commentColor;
@property (nonatomic, assign) CGFloat       disappearDuration;
@property (nonatomic, assign) CGFloat       appearDuration;
@property (nonatomic, strong) ChatLayout    *layout;

+ (instancetype)defaultConfig;
@end

@interface ChatLayout : NSObject
@property (nonatomic, assign) UIEdgeInsets      padding;
@property (nonatomic, assign) CGFloat           commentSpace;
@property (nonatomic, assign) CGFloat           cellSpace;
@property (nonatomic, assign) CGFloat           minimumHeight;
@property (nonatomic, assign) CGFloat           maximumWidth;
@property (nonatomic, assign) BOOL              allowLineBreak;
@property (nonatomic, strong) UIColor           *backgroundColor;
@property (nonatomic, assign, readonly) CGFloat maxCommentWidth;

+ (instancetype)defaultLayout;
@end

@interface CommentLabel : UILabel
@property (nonatomic, assign) BOOL      allowLineBreak;
@property (nonatomic, assign) CGFloat   maxCommentWidth;

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color allowLineBreak:(BOOL)allowLineBreak maxWidth:(CGFloat)maxWidth;

@end