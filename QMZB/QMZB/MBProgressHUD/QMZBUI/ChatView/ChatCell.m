//
//  ChatCell.m
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/12.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import "ChatCell.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"
#import "EmojiScanner.h"

@implementation ChatCell

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment config:(ChatConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        CGPoint namePos = CGPointMake(config.layout.padding.left,  config.layout.padding.top);
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(namePos.x, namePos.y, 0, 0)];
        self.nameLabel.font = config.nameFont;
        self.nameLabel.textColor = config.nameColor;
        self.nameLabel.text = name;
        [self.nameLabel sizeToFit];
        
        CGPoint commentPos = CGPointMake(self.nameLabel.x + self.nameLabel.width + config.layout.commentSpace, self.nameLabel.y);
        self.commentLabel = [[CommentLabel alloc]initWithFrame:CGRectMake(commentPos.x, commentPos.y, 0, 0)
                                                          font:config.commentFont
                                                         color:config.commentColor
                                                allowLineBreak:config.layout.allowLineBreak
                                                      maxWidth:config.layout.maxCommentWidth - self.nameLabel.width - config.layout.commentSpace];
//        self.commentLabel.text = comment;
        self.commentLabel.attributedText = [EmojiScanner scanText:comment];
        [self.commentLabel sizeToFit];
        
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name comment:(NSString *)comment
{
    return [self initWithFrame:frame name:name comment:comment config:[ChatConfig defaultConfig]];
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.commentLabel];
    
    CGFloat width = self.commentLabel.x + self.commentLabel.width + self.config.layout.padding.right;
    width = MIN(width, self.config.layout.maxCommentWidth + self.config.layout.padding.left + self.config.layout.padding.right);
    CGFloat height = MAX(self.commentLabel.height + self.config.layout.padding.top + self.config.layout.padding.bottom, self.config.layout.minimumHeight);
    
    self.frame = CGRectMake(0, 0, width, height);
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgView.image = [UIImage imageNamed:@"bg_msg"];
    
    if (height == self.config.layout.minimumHeight) {
        self.nameLabel.y = (height - self.nameLabel.height) / 2;
        self.commentLabel.y = self.nameLabel.y;
    }

    [self insertSubview:bgView atIndex:0];
}

@end

@implementation ChatConfig

+ (instancetype)defaultConfig
{
    static ChatConfig * config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [ChatConfig new];
        config.layout = [ChatLayout defaultLayout];
        config.commentFont = [UIFont systemFontOfSize:14];
        config.commentColor = [UIColor colorFromHexString:@"#393939"];
        config.nameFont = [UIFont boldSystemFontOfSize:14];
        config.nameColor = [UIColor colorFromHexString:@"#35c681"];
        config.disappearDuration = 6.0;
        config.appearDuration = .5;
    });
    
    return config;
}


@end

@implementation ChatLayout

+ (instancetype)defaultLayout
{
    static ChatLayout *layout;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layout = [ChatLayout new];
        layout.padding = UIEdgeInsetsMake(5, 12, 5, 12);
        layout.commentSpace = 8.0;
        layout.cellSpace = 5.0;
        layout.minimumHeight = 29;
        layout.maximumWidth = [[UIScreen mainScreen]bounds].size.width - 20;
        layout.allowLineBreak = YES;
        layout.backgroundColor = [UIColor clearColor];
    });
    
    return layout;
}

- (CGFloat)maxCommentWidth
{
    return self.maximumWidth - (self.padding.left + self.padding.right);
}

@end

@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color allowLineBreak:(BOOL)allowLineBreak maxWidth:(CGFloat)maxWidth
{
    self  = [super initWithFrame:frame];
    if (self) {
        self.allowLineBreak = allowLineBreak;
        self.maxCommentWidth = maxWidth;
        self.textColor = color;
        self.font = font;
    }
    
    return self;
}

- (void)sizeToFit
{
    if (self.allowLineBreak) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
    }
    
    [super sizeToFit];
    
    self.width = MIN(self.maxCommentWidth, self.width);
    [super sizeToFit];
}

@end
