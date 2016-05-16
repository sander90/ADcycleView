//
//  CycleScrollerView.h
//  ScrollerViewDome
//
//  Created by shansander on 16/5/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDCycleView.h"

@class CycleScrollerView;



@protocol CycleScrollerViewDataDelegate <NSObject>

@required

- (SDCycleView *)CycleScrollerView:(CycleScrollerView * )cycleView indexpath:(NSInteger)row;

- (NSInteger)CycleScrollerViewOfnumberRow;

@optional

- (void)CycleScrollerView:(CycleScrollerView * )cycleView didSeclectedIndexPath:(NSInteger)row;

- (NSTimeInterval)CycleScrollerViewRunTimer;


@end

typedef enum{
    ScrollerViewDirction_Lateral, // 横向
    ScrollerViewDirction_Portrait // 纵向
}ScrollerViewDirction;

typedef enum {
    scroller_drop_equal,
    scroller_drop_add,
    scroller_drop_cut
}ScrollerViewDropDirction;

@interface CycleScrollerView : UIView

@property (nonatomic, strong) id<CycleScrollerViewDataDelegate> dataDelegate;

@property (nonatomic, assign)ScrollerViewDirction dirction;

@property (nonatomic, assign) BOOL ShowPageControll;

- (SDCycleView *)GetDefineSycleView;

@end
