//
//  QMZBSortGroup.m
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import "QMZBSortGroup.h"
#import "QMZBSortItem.h"

@interface QMZBSortGroup()
{
    NSArray *_sortArrays;
    UIView *_line;
    int _currentPosition;
}

@end
@implementation QMZBSortGroup

- (id) initWithFrame:(CGRect)frame sortArrays:(NSArray *) arrays defaultPosition:(int) position
{
    self = [super initWithFrame:frame];
    if (self) {
        _sortArrays = arrays;
        
        for (QMZBSortItem *sortView in _sortArrays) {
            [sortView addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _line.backgroundColor = COLOR(25, 151, 220, 1);
        [self addSubview:_line];
        
        [self setPosition:position];
    }
    return self;
}

- (void) itemClick:(id)sender
{
    for (QMZBSortItem *sortView in _sortArrays) {
        if(sortView != sender){
            [sortView setState:SortDefault];
        }else {
            [UIView animateWithDuration:0.25 animations:^(void){
                _line.frame =CGRectMake(sortView.frame.origin.x + 10, 0, sortView.frame.size.width - 20, self.frame.size.height);
            }];
            int position = (int) [_sortArrays indexOfObject:sortView];
            if(position == _currentPosition){
                if([sortView sortState] == SortDesc){
                    [sortView setState:SortAsc];
                }else if([sortView sortState] == SortAsc){
                    [sortView setState:SortDesc];
                }
            }else {
                [sortView setState:SortDesc];// 恢复上次排序
                
            }
            _currentPosition = position;
        }
    }
}

- (void) setPosition:(int) position
{
    QMZBSortItem *sortView = _sortArrays[position];
    [self itemClick:sortView];
}


@end
