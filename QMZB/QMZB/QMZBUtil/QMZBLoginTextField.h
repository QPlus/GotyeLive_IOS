//
//  QMZBLoginTextField.h
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMZBLoginTextField : UITextField

@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, strong) UIImageView *leftImage;

- (UITextField *)textWithleftImage:(NSString *)leftIcon placeName:(NSString *)placeName;

@end
