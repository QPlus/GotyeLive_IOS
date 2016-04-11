//
//  QMZBSortItem.h
//  QMZB
//
//  Created by Jim on 16/3/23.
//  Copyright © 2016年 yangchuanshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMZBUIUtil.h"

typedef enum{
    SortDefault = 0,// 未选中
    SortDesc = 1, // 降序
    SortAsc = 2,// 升序
    SortNone = 3,// 未选中
} SortState;

#define SORT_IMAGE_WIDTH 12.0f
#define SORT_IMAGE_HEIGHT 12.0f

#define LABEL_HEIGHT ((40.f)*ScreenWidth/320.f)
@interface QMZBSortItem : UIControl
{
    CALayer *_sortImage;// 箭头图片
}
@property (nonatomic,strong) UILabel *nameLabel; // 名称标签
@property (nonatomic, assign) SortState sortState;

- (id)initWithFrame:(CGRect)frame andName:(NSString *)name sortImage:(NSString *)imageName state:(SortState) state;

- (void)setState:(SortState) state;

@end
