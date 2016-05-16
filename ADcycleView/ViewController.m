//
//  ViewController.m
//  ADcycleView
//
//  Created by shansander on 16/5/16.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollerView.h"

@interface ViewController ()<CycleScrollerViewDataDelegate>

@property (nonatomic, weak) IBOutlet CycleScrollerView * thepartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thepartView.dataDelegate = self;
    self.thepartView.dirction = ScrollerViewDirction_Portrait;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger )CycleScrollerViewOfnumberRow
{
    return 3;
}

- (SDCycleView *)CycleScrollerView:(CycleScrollerView *)cycleView indexpath:(NSInteger)row
{
    SDCycleView * view = [cycleView GetDefineSycleView];
    if (row == 0) {
        view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else if (row == 1){
        view.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    }else{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    }
    return view;
}

- (NSTimeInterval)CycleScrollerViewRunTimer
{
    return 2;
}
- (void)CycleScrollerView:(CycleScrollerView *)cycleView didSeclectedIndexPath:(NSInteger)row
{
    NSLog(@"selected row = %ld",(long)row);
}

@end
