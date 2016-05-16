# ADcycleView

* 如何使用

    self.thepartView.dirction = ScrollerViewDirction_Portrait;

设置滚动的方向。

每个界面的设置由

```oc
- (SDCycleView *)CycleScrollerView:(CycleScrollerView *)cycleView indexpath:(NSInteger)row
```

代理来实现

