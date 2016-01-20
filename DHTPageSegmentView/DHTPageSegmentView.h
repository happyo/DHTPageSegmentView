//
//  DHTPageSegmentView.h
//  DHTPageSegmentView
//
//  Created by happyo on 16/1/20.
//  Copyright © 2016年 happyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHTPageSegmentViewDelegate <NSObject>

/**
 *  通过代理方法获取当前是否是显示 popView，及获取 popView 的高度，以便修改 其它view 的 frame，防止覆盖等错误
 */
- (void)shouldPopView:(BOOL)pop height:(CGFloat)height;

@optional

- (void)didSelectedItemAtIndex:(NSInteger)index;

@end

@interface DHTPageSegmentView : UIView

@property (nonatomic, weak) id<DHTPageSegmentViewDelegate> delegate;

/**
 *  所有按钮的名称
 */
@property (nonatomic, copy) NSArray *itemTitles;

/**
 *  选中按钮的位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;




- (void)reloadPageSegmentView;

@end
