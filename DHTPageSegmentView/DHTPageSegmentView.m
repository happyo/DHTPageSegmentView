//
//  DHTPageSegmentView.m
//  DHTPageSegmentView
//
//  Created by happyo on 16/1/20.
//  Copyright © 2016年 happyo. All rights reserved.
//

#import "DHTPageSegmentView.h"
#import "DHTPagePopView.h"

#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

const static float kArrowViewBorder = 24;
const static float kAnimationDuration = 0.2;

@interface DHTPageSegmentView () <DHTPagePopViewDelegate>

@property (nonatomic, strong) UIScrollView *pageScrollView;

@property (nonatomic, strong) DHTPagePopView *popView;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) NSMutableArray *allItemBtns;

@property (nonatomic, strong) NSMutableArray *allSpliteViews;

@property (nonatomic, assign) BOOL isShowPopView;

@property (nonatomic, assign) NSInteger numPerLine;

@end
@implementation DHTPageSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureViews];
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    }
    
    return self;
}

- (void)dealloc
{
    self.popView.delegate = nil;
}

#pragma mark -- Public Methods --

- (void)reloadPageSegmentView
{
    if (self.itemTitles.count) {
        
        if (self.itemTitles.count < self.numPerLine) {
            self.arrowView.hidden = YES;
        } else {
            self.arrowView.hidden = NO;
        }
        
        CGFloat scrollContentWidth = [self setContentWidthAndItems];
        self.pageScrollView.contentSize = CGSizeMake(scrollContentWidth, 0);
        
        // 选中当前按下的button
        UIButton *btnSelect = self.allItemBtns[self.selectedIndex];
        btnSelect.selected = YES;
        
        [self shouldScrollToRightPlace];
    }
}


#pragma mark -- Private Methods --

- (void)configureViews
{
    CGFloat pageSegmentWidth = self.bounds.size.width;
    CGFloat pageSegmentHeight = self.bounds.size.height;
    
    // configure scroll view
    self.pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, pageSegmentWidth - pageSegmentHeight, pageSegmentHeight)];
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.backgroundColor = [UIColor clearColor];
    self.pageScrollView.bouncesZoom = NO;
    [self addSubview:self.pageScrollView];
    
    // configure arrow view
    self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kArrowViewBorder, kArrowViewBorder)];
    self.arrowView.image = [UIImage imageNamed:@"album_arrow_icon"];
    self.arrowView.center = CGPointMake(pageSegmentWidth - pageSegmentHeight / 2, pageSegmentHeight / 2);
    [self addSubview:self.arrowView];
    
    // add gesture to arrow view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowViewClicked)];
    self.arrowView.userInteractionEnabled = YES;
    [self.arrowView addGestureRecognizer:tapGestureRecognizer];
    
    // 默认选中第一个
    self.selectedIndex = 0;
    
    // 默认一行四个
    self.numPerLine = 4;
}

- (CGFloat)setContentWidthAndItems
{
    [self.allItemBtns removeAllObjects];
    [self.pageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat buttonX = 0.0;
    CGFloat buttonWidth = self.pageScrollView.bounds.size.width / self.numPerLine;
    CGFloat buttonHeight = self.pageScrollView.bounds.size.height;
    
    for (int index = 0; index < self.itemTitles.count; index ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0.0, buttonWidth, buttonHeight);
        [button setTitle:self.itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitleColor:RGBACOLOR(100, 100, 100, 1) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setExclusiveTouch:YES];
        [button setTitleColor:RGBACOLOR(228, 39, 55, 1) forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth - 0.5, 12.5, 0.5, buttonHeight - 25)];
        view.backgroundColor = RGBACOLOR(219, 219, 219, 1);
        [button addSubview:view];
        
        // 最后一个不显示分割线
        if (index == self.itemTitles.count - 1) {
            view.hidden = YES;
        }
        
        [self.pageScrollView addSubview:button];
        
        [self.allItemBtns addObject:button];
        [self.allSpliteViews addObject:view];
        buttonX += buttonWidth;
    }
    
    return buttonX;
}



- (CGFloat)heightForPopView
{
    CGFloat lineHeight = self.pageScrollView.bounds.size.height;
    NSInteger numOfLine = self.itemTitles.count % self.numPerLine == 0 ? self.itemTitles.count / self.numPerLine : (self.itemTitles.count / self.numPerLine + 1);
    return lineHeight * (numOfLine + 1) + 5;
}

/**
 *  弹出，收回动画
 */
- (void)showAnimation
{
    
    if (self.isShowPopView) {
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            self.pageScrollView.hidden = YES;
            
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self heightForPopView]);
        } completion:^(BOOL finished) {
            
            self.popView.selectedIndex = self.selectedIndex;
            [self.popView updateSelectedItems];
            
            self.popView.hidden = NO;
            
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            
            self.popView.hidden = !self.popView.hidden;
            self.arrowView.transform = CGAffineTransformIdentity;
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.pageScrollView.bounds.size.height);
            
        } completion:^(BOOL finished) {
            
            self.pageScrollView.hidden = !self.pageScrollView.hidden;
            
        }];
    }
}

- (void)shouldScrollToRightPlace
{
    CGFloat buttonWidth = self.pageScrollView.bounds.size.width / self.numPerLine;
    
    // 滚动到选择的button处
    if (self.selectedIndex > 1 && self.selectedIndex < self.itemTitles.count - 1) {
        [self.pageScrollView setContentOffset:CGPointMake(((self.selectedIndex - 2) * buttonWidth), 0) animated:YES];
    } else if (self.selectedIndex <= 1 && self.selectedIndex >= 0) {
        [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (self.selectedIndex < self.itemTitles.count && self.selectedIndex > self.itemTitles.count - 1) {
        [self.pageScrollView setContentOffset:CGPointMake((self.selectedIndex - 3) * buttonWidth, 0) animated:YES];
    }

}

#pragma mark -- DHTPagePopViewDelegate --

- (void)itemPressedWithIndex:(NSInteger)index
{
    [self arrowViewClicked];
    [self changeBtnStateAtIndex:index];
}

#pragma mark -- Actions --

- (void)arrowViewClicked
{
    self.isShowPopView = !self.isShowPopView;
    
    [self.delegate shouldPopView:self.isShowPopView height:[self heightForPopView]];
    
    [self showAnimation];
}


- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [self.allItemBtns indexOfObject:button];

    [self changeBtnStateAtIndex:index];
}

- (void)changeBtnStateAtIndex:(NSInteger)index
{
    // 将之前选中的取消
    UIButton *btn = self.allItemBtns[self.selectedIndex];
    btn.selected = NO;
    
    // 选中当前按下的button
    self.selectedIndex = index;
    UIButton *btnSelect = self.allItemBtns[self.selectedIndex];
    btnSelect.selected = YES;
    
    [self.delegate didSelectedItemAtIndex:index];
    
    [self shouldScrollToRightPlace];

}


#pragma mark -- Setters && Getters --

- (DHTPagePopView *)popView
{
    if (!_popView) {
        _popView = [[DHTPagePopView alloc] initWithFrame:CGRectMake(0, self.pageScrollView.bounds.size.height, self.bounds.size.width, [self heightForPopView])];
        _popView.itemWidth = self.bounds.size.width / self.numPerLine;
        _popView.itemHeight = self.pageScrollView.bounds.size.height;
        _popView.delegate = self;
        _popView.itemTitles = self.itemTitles;
        
        [self addSubview:self.popView];
    }
    
    return _popView;
}

- (NSMutableArray *)allItemBtns
{
    if (!_allItemBtns) {
        _allItemBtns = [NSMutableArray array];
    }
    
    return _allItemBtns;
}

- (NSMutableArray *)allSpliteViews
{
    if (!_allSpliteViews) {
        _allSpliteViews = [NSMutableArray array];
    }
    
    return _allSpliteViews;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
