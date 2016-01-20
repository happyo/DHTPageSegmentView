//
//  ViewController.m
//  DHTPageSegmentView
//
//  Created by happyo on 16/1/20.
//  Copyright © 2016年 happyo. All rights reserved.
//

#import "ViewController.h"
#import "DHTPageSegmentView.h"

const static float kPageSegmentViewHeight = 50;

@interface ViewController () <DHTPageSegmentViewDelegate>

@property (nonatomic, strong) DHTPageSegmentView *pageSegmentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageSegmentView = [[DHTPageSegmentView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, kPageSegmentViewHeight)];
    
    [self.view addSubview:self.pageSegmentView];
    
    self.pageSegmentView.delegate = self;
    self.pageSegmentView.itemTitles = @[@"123", @"345", @"456", @"567", @"568"];
    [self.pageSegmentView reloadPageSegmentView];
}

- (void)didSelectedItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld", index);
}

- (void)shouldPopView:(BOOL)pop height:(CGFloat)height
{
    // 需要在外面改变 DHTPageSegmentView 的 frame 使其能正常显示，
    if (pop) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pageSegmentView.frame = CGRectMake(self.pageSegmentView.frame.origin.x, self.pageSegmentView.frame.origin.y, self.pageSegmentView.frame.size.width, height);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.pageSegmentView.frame = CGRectMake(self.pageSegmentView.frame.origin.x, self.pageSegmentView.frame.origin.y, self.pageSegmentView.frame.size.width, kPageSegmentViewHeight);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
