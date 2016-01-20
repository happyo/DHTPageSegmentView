//
//  DHTPagePopView.h
//  DHTPageSegmentView
//
//  Created by happyo on 16/1/20.
//  Copyright © 2016年 happyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHTPagePopViewDelegate <NSObject>

@optional

- (void)itemPressedWithIndex:(NSInteger)index;

@end

@interface DHTPagePopView : UIView

@property (nonatomic, weak) id<DHTPagePopViewDelegate> delegate;

@property (nonatomic, strong) NSArray *itemTitles;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)updateSelectedItems;

@end
