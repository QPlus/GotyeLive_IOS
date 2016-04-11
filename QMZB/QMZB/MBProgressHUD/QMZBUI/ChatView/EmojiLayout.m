//
//  EmojiLayout.m
//  GotyeLiveDemo
//
//  Created by Nick on 16/1/15.
//  Copyright © 2016年 AiLiao. All rights reserved.
//

#import "EmojiLayout.h"

@interface EmojiLayout()

@property (nonatomic, assign) CGFloat cellX;
@property (nonatomic, assign) CGFloat cellY;
@property (nonatomic, assign) BOOL shouldUpdateLayout;

@end
@implementation EmojiLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.itemSize = CGSizeMake(30, 30);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.shouldUpdateLayout = YES;
}

// when ever the bounds change, call layoutAttributesForElementsInRect:
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    self.shouldUpdateLayout = YES;
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *allItems = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in allItems) {
        [self calculateLocationsForCellsWithAttribute:attribute];
    }
    
    return allItems;
}

- (CGSize)collectionViewContentSize
{
    NSUInteger numOfPages = [self.collectionView numberOfItemsInSection:0] / ([self maxColumnCount] * [self maxRowCount]) + 1;
    return CGSizeMake(numOfPages * self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (void)calculateLocationsForCellsWithAttribute:(UICollectionViewLayoutAttributes *)attribute
{
    NSInteger rowCount = [self maxRowCount];
    NSInteger columnCount = [self maxColumnCount];
    CGFloat cellWidth = self.itemSize.width + self.minimumInteritemSpacing;
    CGFloat cellHeight = self.itemSize.height + self.minimumLineSpacing;

    NSInteger index = attribute.indexPath.row;
    NSUInteger currentPage = index / (rowCount * columnCount);
    
    if (self.shouldUpdateLayout) {
        CGFloat displayWidth = cellWidth * (columnCount - 1) + self.itemSize.width;
        CGFloat displatyHeight = cellHeight * (rowCount - 1) + self.itemSize.height;
        self.cellX = self.sectionInset.left + ([self collectionViewLayoutWidth] - displayWidth) / 2;
        self.cellY = self.sectionInset.top + ([self collectionViewLayoutHeight] -  displatyHeight) / 2;
        self.shouldUpdateLayout = NO;
    }
    
    NSInteger row = (index - (currentPage * (rowCount * columnCount)) ) / columnCount;
    NSInteger column = index % columnCount;
    CGFloat x = self.cellX + currentPage * self.collectionView.bounds.size.width + cellWidth * column;
    CGFloat y = self.cellY + cellHeight * row;
    
    attribute.frame = CGRectMake(x, y, attribute.frame.size.width, attribute.frame.size.height);
}

- (CGFloat)collectionViewLayoutWidth
{
    UICollectionView *collectionView = self.collectionView;
    return collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
}

- (CGFloat)collectionViewLayoutHeight
{
    UICollectionView *collectionView = self.collectionView;
    return collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom;
}

- (NSUInteger)maxRowCount
{
    CGFloat layoutHeight = [self collectionViewLayoutHeight];
    return (layoutHeight - self.itemSize.height) / (self.itemSize.height + self.minimumLineSpacing) + 1;
}

- (NSUInteger)maxColumnCount
{
    CGFloat layoutWidth = [self collectionViewLayoutWidth];
    return (layoutWidth - self.itemSize.width) / (self.itemSize.width + self.minimumInteritemSpacing) + 1;
}

@end
