//
//  DHTPagePopView.m
//  DHTPageSegmentView
//
//  Created by happyo on 16/1/20.
//  Copyright © 2016年 happyo. All rights reserved.
//

#import "DHTPagePopView.h"

#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface DHTPagePopView ()

@property (nonatomic, strong) NSMutableArray *allItemBtns;

@end
@implementation DHTPagePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateSubViewsWithItems
{
    [self.allItemBtns removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeAllObjects)];
    
    CGFloat buttonX = 0.0;
    CGFloat buttonY = 0.0;
    for (int index = 0; index < self.itemTitles.count; index++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(buttonX, buttonY, self.itemWidth, self.itemHeight)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.frame = CGRectMake(8, 5, self.itemWidth - 16, self.itemHeight - 10);
        [button setTitle:self.itemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setExclusiveTouch:YES];
        [button setTitleColor:RGBACOLOR(228, 39, 55, 1) forState:UIControlStateSelected];
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:0];
        [button.layer setBorderWidth:0.5];
        
        UIColor *color = RGBACOLOR(205, 205, 205, 1);
        
        [button.layer setBorderColor:color.CGColor];
        
        [view addSubview:button];
        [self addSubview:view];
        
        [self.allItemBtns addObject:button];
        
        buttonX += self.itemWidth;
        
        // 一行装不下了就换行
        if (buttonX >= self.bounds.size.width)
        {
            buttonX = 0.0;
            buttonY += self.itemHeight;
        }
        
    }
}

- (void)itemPressed:(UIButton *)button
{
    UIButton *btnPreSelected = self.allItemBtns[self.selectedIndex];
    btnPreSelected.selected = NO;
    
    self.selectedIndex = button.tag;
    UIButton *btn = self.allItemBtns[self.selectedIndex];
    btn.selected = YES;
    
    [self.delegate itemPressedWithIndex:button.tag];
}

#pragma mark -- Public Methods --

- (void)updateSelectedItems
{
    // 先将所有的button置为非选
    for (UIButton *button in self.allItemBtns) {
        button.selected = NO;
    }
    
    // 选中指定的button
    UIButton *btn = self.allItemBtns[self.selectedIndex];
    btn.selected = YES;
}


#pragma mark -- Setters && Getters --

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
}

- (NSMutableArray *)allItemBtns
{
    if (!_allItemBtns) {
        _allItemBtns = [NSMutableArray array];
    }
    
    return _allItemBtns;
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    _itemTitles = itemTitles;
    
    [self updateSubViewsWithItems];
}

@end
