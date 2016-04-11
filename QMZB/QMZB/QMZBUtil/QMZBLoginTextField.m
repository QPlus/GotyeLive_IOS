//
//  QMZBLoginTextField.m
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBLoginTextField.h"
#import "QMZBUIUtil.h"

@implementation QMZBLoginTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UITextField *)textWithleftImage:(NSString *)leftIcon placeName:(NSString *)placeName;
{
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.frame = self.bounds;
    signBtn.backgroundColor = WHITE_COLOR;
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [signBtn.layer setBorderWidth:1.5f];   //边框宽度
    [signBtn.layer setBorderColor:WHITE_COLOR.CGColor];//边框颜色
    signBtn.userInteractionEnabled = false;
    [self addSubview:signBtn];
    
    self.textColor = TEXT_BLACK_COLOR;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.placeholder = placeName;
    [self setValue:DIVIDE_LINE_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont boldSystemFontOfSize:13.0f] forKeyPath:@"_placeholderLabel.font"];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    _leftImage.image = [UIImage imageNamed:leftIcon];
    _leftImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame)-10, 10, 0.5f, self.frame.size.height - 20)];
    line.backgroundColor = DIVIDE_LINE_COLOR;
    [self addSubview:line];
    
    self.leftView = _leftImage;
    self.leftViewMode = self.rightViewMode = UITextFieldViewModeAlways;
    
    return self;
}

//设置placeholder的位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+50, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

@end
