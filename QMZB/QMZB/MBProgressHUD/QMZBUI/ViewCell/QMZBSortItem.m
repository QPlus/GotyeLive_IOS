//
//  QMZBSortItem.m
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBSortItem.h"

@implementation QMZBSortItem

- (id) initWithFrame:(CGRect)frame andName:(NSString *)name sortImage:(NSString *)imageName state:(SortState) state
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGSize text = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f]}];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height*0.5 - LABEL_HEIGHT*0.5, self.frame.size.width, LABEL_HEIGHT)];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.textColor = TEXT_BLACK_COLOR;
        _nameLabel.text = name;
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        if(state != SortNone){
            _sortImage = [CALayer layer];
            
            _sortImage.frame = CGRectMake(ScreenWidth/8 + text.width/2.f, frame.size.height*0.5 - SORT_IMAGE_HEIGHT*0.5, SORT_IMAGE_WIDTH, SORT_IMAGE_HEIGHT);
            _sortImage.contentsGravity = kCAGravityResizeAspect;
            _sortImage.contents = (id)[UIImage imageNamed:imageName].CGImage;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                _sortImage.contentsScale = [[UIScreen mainScreen] scale];
            }
            [[self layer] addSublayer:_sortImage];
            
        }
        
        [self setState:state];
    }
    return self;
}


- (void)setState:(SortState) state
{
    [self setSortState:state];
    switch (state) {
        case SortDefault:
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                _sortImage.hidden =YES;
            }];
        }
        case SortNone:
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                _sortImage.hidden =YES;
            }];
        }
            break;
        case SortDesc:
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                _sortImage.hidden =NO;
                _sortImage.transform = CATransform3DIdentity;
                
            }];
        }
            break;
        case SortAsc:
        {
            
            [UIView animateWithDuration:0.25 animations:^(void){
                _sortImage.hidden =NO;
                _sortImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                
            }];
            
        }
            break;
    }
}



@end
