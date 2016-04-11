//
//  ItemView.h
//  huiyin
//
//  Created by 7ien on 14-11-17.
//  Copyright (c) 2014年 7ien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMZBItemView;
@protocol QMZBItemViewDelegate <NSObject>

- (void)didSelectItemView:(QMZBItemView *)itemView;

@end

@interface QMZBItemView : UIView
{
@private
    UIButton *_itemButton;
    UILabel  *_textLabel;
}

@property (nonatomic, assign) id <QMZBItemViewDelegate> delegate;
@property (nonatomic, readonly, retain) UIButton *itemButton;
@property (nonatomic, readonly, retain) UILabel  *textLabel;
- (void)isSelected:(BOOL)selected;

@end
