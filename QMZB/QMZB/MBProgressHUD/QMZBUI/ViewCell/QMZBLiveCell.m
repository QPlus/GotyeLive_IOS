//
//  QMZBLiveCell.m
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBLiveCell.h"
#import "QMZBUIUtil.h"
#import "UIImageView+WebCache.h"
#import "QMZBNetWork.h"

@interface QMZBLiveCell()

@property (nonatomic , strong) id object;

@end
@implementation QMZBLiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_headImage];
        
        _userName = [[UILabel alloc] init];
        _userName.frame = CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, 2, ScreenWidth/2, 30);
        _userName.font = [UIFont boldSystemFontOfSize:14.f];
        _userName.textColor = TEXT_BLACK_COLOR;
        [self addSubview:_userName];
        
        _liveRoomTopic = [[UILabel alloc] init];
        _liveRoomTopic.frame = CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, 32, ScreenWidth/2, 30);
        _liveRoomTopic.font = [UIFont boldSystemFontOfSize:14.f];
        _liveRoomTopic.textColor = TEXT_BLACK_COLOR;
        [self addSubview:_liveRoomTopic];
        
        _followCount = [[UILabel alloc] init];
        _followCount.frame = CGRectMake(CGRectGetMaxX(_headImage.frame) + 10, 62, 120, 30);
        _followCount.font = [UIFont boldSystemFontOfSize:14.f];
        _followCount.textColor = TEXT_BLACK_COLOR;
        [self addSubview:_followCount];
        
        _isOnlive = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, 40, 20)];
        _isOnlive.image = [UIImage imageNamed:@"zhibozhong"];
        _isOnlive.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_isOnlive];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.frame = CGRectMake(ScreenWidth-100, 62, 80, 30);
        [_followButton setTitleColor:TEXT_BLACK_COLOR forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_followButton];
        _followButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        
//        UIImageView *peoplecount = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, 40, 20)];
//        peoplecount.image = [UIImage imageNamed:@"peoplecount"];
//        peoplecount.contentMode = UIViewContentModeScaleAspectFill;
//        [self addSubview:peoplecount];
        
        UIView *lineName = [[UIView alloc] initWithFrame:CGRectMake(0, 99, ScreenWidth, 1.f)];
        lineName.backgroundColor = DIVIDE_LINE_COLOR;
        [self  addSubview:lineName];
        
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.object) {
        
        _listModel = self.object;
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *img = [UIImage imageWithContentsOfFile:fullPath];
        _headImage.image = img;
        
        [_headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/live/GetUserHeadPic?id=%@",BaseServiceUrl,_listModel.anchorIcon]] placeholderImage:[UIImage imageNamed:@"user_default_head"]];
        
        _userName.text = [NSString stringWithFormat:@"%@",_listModel.liveRoomName];
        _liveRoomTopic.text = [NSString stringWithFormat:@"%@",_listModel.liveRoomTopic];
        _followCount.text = [NSString stringWithFormat:@"%@",_listModel.playerCount];
        if ([_listModel.isFollow integerValue] == 1) {
            
            [_followButton setImage:[UIImage imageNamed:@"icon_follow_yes"] forState:UIControlStateNormal];
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            //_followButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,_followButton.titleLabel.bounds.size.width);
        }else {
            [_followButton setTitle:@"未关注" forState:UIControlStateNormal];
            [_followButton setImage:[UIImage imageNamed:@"icon_follow_no"] forState:UIControlStateNormal];
        }

        [_followButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)fillCellWithObject:(id)object
{
    self.object = object;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)click:(id)seder
{
    UIButton *button = seder;
    if (self.didSelectedButton != nil) {
        self.didSelectedButton(button);
    }
}

@end
