//
//  ChatView.m
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/12.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import "ChatView.h"
#import "ChatCell.h"
#import "UIView+Extension.h"

@interface ChatView()
@property (nonatomic, strong) NSMutableArray * visibleCells;
@end

@implementation ChatView

- (instancetype)initWithFrame:(CGRect)frame config:(ChatConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithConfig:config];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame config:[ChatConfig defaultConfig]];
}

- (void)awakeFromNib
{
    [self initWithConfig:[ChatConfig defaultConfig]];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self setupView];
}

- (void)initWithConfig:(ChatConfig *)config
{
    self.config = config;
    self.visibleCells = [NSMutableArray array];
}

- (void)setupView
{
    self.backgroundColor = self.config.layout.backgroundColor;
}

- (void)addCell:(ChatCell *)cell
{
    cell.frame = CGRectMake(0, self.height, cell.width, cell.height);
    [self.visibleCells addObject:cell];
    [self addSubview:cell];
    
    [UIView animateWithDuration:self.config.appearDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat dy = cell.height + self.config.layout.cellSpace;
        [self.visibleCells enumerateObjectsUsingBlock:^(ChatCell   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGAffineTransform origin = obj.transform;
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -dy);
            obj.transform = CGAffineTransformConcat(origin, transform);
        }];
    } completion:nil];
    
    [UIView animateWithDuration:self.config.disappearDuration delay:self.config.appearDuration options:UIViewAnimationOptionCurveEaseIn animations:^{
        cell.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [cell removeFromSuperview];
            [self.visibleCells removeObject:cell];
        }
    }];
}

- (void)addCellWithName:(NSString *)name comment:(NSString *)comment
{
    ChatCell *cell = [[ChatCell alloc]initWithFrame:CGRectZero name:name comment:comment config:self.config];
    [self addCell:cell];
}

- (void)clear
{
    NSArray *copy = [NSArray arrayWithArray:self.visibleCells];
    [copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.visibleCells removeAllObjects];
}

@end
