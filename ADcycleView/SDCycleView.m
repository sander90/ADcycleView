//
//  SDCycleView.m
//  ScrollerViewDome
//
//  Created by shansander on 16/5/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "SDCycleView.h"

@implementation SDCycleView


- (SDCycleView *)copyView
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
