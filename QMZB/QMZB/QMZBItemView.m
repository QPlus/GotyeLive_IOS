//
//  ItemView.m
//  huiyin
//
//  Created by 7ien on 14-11-17.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import "QMZBItemView.h"
#import "QMZBUIUtil.h"

#define kItemButtonHeight 35
#define kTextLabelHeight 10

@implementation QMZBItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - getter methods
- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont boldSystemFontOfSize:11];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = TEXT_BLACK_COLOR;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIButton *)itemButton
{
    if (_itemButton == nil) {
        
        _itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 代理设计模式
        [_itemButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _itemButton.showsTouchWhenHighlighted = YES;
        
        // 目标-动作设计模式
        /*
         [_itemButton addTarget:_target action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        [self addSubview:_itemButton];
    }
    return _itemButton;
}

#pragma mark - Public Method
- (void)isSelected:(BOOL)selected
{
    _itemButton.selected = selected;
    _textLabel.highlighted = selected;
    
    
    if(selected){
        _textLabel.textColor = ORANGE_COLOR;
    } else {
        _textLabel.textColor = TEXT_BLACK_COLOR;
    }
}

#pragma mark - Layout Method
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 如果支持横竖屏幕，通过[UIApplication sharedApplication].statusBarOrientation;
    // [itemview setNeedsLayout];
    
    _itemButton.frame = CGRectMake(0, 0, self.frame.size.width, kItemButtonHeight);
    _textLabel.frame = CGRectMake(0, _itemButton.frame.size.height, self.frame.size.width, kTextLabelHeight);
}


#pragma mark - Action Method
- (void)click:(UIButton *)item
{
    if ([self.delegate respondsToSelector:@selector(didSelectItemView:)]) {
        [self.delegate didSelectItemView:self];
    }
}


@end
