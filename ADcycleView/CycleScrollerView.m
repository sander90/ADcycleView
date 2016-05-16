//
//  CycleScrollerView.m
//  ScrollerViewDome
//
//  Created by shansander on 16/5/14.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "CycleScrollerView.h"

#define MOVEPoint CGPointMake(self.bounds.size.width, 0)
#define LATERAL_CURRENTPAGE_contentOffset CGRectMake(self.bounds.size.width, 0,self.bounds.size.width,self.bounds.size.height)
#define LATERAL_NEXTPAGE_contentOffset CGRectMake(self.bounds.size.width * 2, 0,self.bounds.size.width,self.bounds.size.height)
#define LATERAL_PREVIOUSPAGE_contentOffset CGRectMake(0, 0,self.bounds.size.width,self.bounds.size.height)


NSInteger const MaxCountOfScrollerContent = 3;

@interface CycleScrollerView()<UIScrollViewDelegate>
{
    UIScrollView * theRootScrollView;
    
    UIPageControl * thePageView;
    
    NSInteger numberOfItem;
    
    NSInteger currentOfStep;
    
    NSInteger lateral_model;
    NSInteger portrait_model;
    
    NSTimer * runtimer;
    
    NSTimeInterval runTimerWithTime;
    
    BOOL isCanAutoRunCycle;
    
}

@property (nonatomic, strong) NSMutableArray * theScrollDataList;

@end

@implementation CycleScrollerView

- (void)awakeFromNib
{
    [super awakeFromNib];
   
    [self initScrollView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //加载 scroll 的数据
    NSLog(@"layout");
    [self loadScrollData];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"这个一定要吊用");

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
    }
    return self;
}
#pragma mark - 初始化界面
- (void)initScrollView
{
    [self setTranslatesAutoresizingMaskIntoConstraints:false];
    self.theScrollDataList = [[NSMutableArray alloc] init];
    numberOfItem = 0;
    currentOfStep = 0;
    // 横向
    lateral_model = 1; portrait_model = 0;
    // 建立基础的界面
    [self buildingBaseView];
    
    runTimerWithTime = 2;
    isCanAutoRunCycle = true;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapScrollerView:)];
    [self addGestureRecognizer:tap];
    
}
#pragma mark - 建立基础的界面
- (void)buildingBaseView
{
    theRootScrollView = [[UIScrollView alloc] init];
    theRootScrollView.showsVerticalScrollIndicator = NO;
    theRootScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:theRootScrollView];
    theRootScrollView.layer.borderColor = [UIColor redColor].CGColor;
    theRootScrollView.layer.borderWidth = 2.0f;
    theRootScrollView.pagingEnabled = YES;
    theRootScrollView.delegate = self;
    [theRootScrollView setTranslatesAutoresizingMaskIntoConstraints:false];
    thePageView = [[UIPageControl alloc] init];
    thePageView.backgroundColor = [UIColor redColor];
    [self addSubview:thePageView];
    thePageView.numberOfPages = 4;
    [self initViewFrame];
}
#pragma mark - 界面中frame规定
- (void)initViewFrame
{
    
    NSLayoutConstraint * left_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
//    NSLayoutConstraint * right_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * width_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint * top_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//    NSLayoutConstraint * bottom_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint * height_Constraint = [NSLayoutConstraint constraintWithItem:theRootScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self addConstraints:@[left_Constraint,top_Constraint,width_Constraint,height_Constraint]];
    
    
//    theRootScrollView.frame = self.bounds;
//    thePageView.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
//    thePageView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
//    if (!self.ShowPageControll) {
//        thePageView.hidden = YES;
//    }
}
#pragma mark - 加载数据
- (void)loadScrollData
{
    if (self.dirction == ScrollerViewDirction_Portrait) {
        lateral_model = 0;
        portrait_model = 1;
    }
    
    numberOfItem = [self.dataDelegate CycleScrollerViewOfnumberRow];
    for (NSInteger i = 0; i < numberOfItem; i ++) {
        SDCycleView * one = [self.dataDelegate CycleScrollerView:self indexpath:i];
        one.frame = CGRectMake(i * self.bounds.size.width * lateral_model, i * self.bounds.size.height * portrait_model, one.frame.size.width, one.frame.size.height);
        [theRootScrollView addSubview:one];
        [self.theScrollDataList addObject:one];
    }
    if (numberOfItem == 2) {
        SDCycleView * one = self.theScrollDataList[0];
        SDCycleView * copyOne = [one copyView];
        copyOne.frame = CGRectMake(2 * self.bounds.size.width * lateral_model , 2 * self.bounds.size.height * portrait_model , one.frame.size.width, one.frame.size.height);
        [self.theScrollDataList addObject:copyOne];
        [theRootScrollView addSubview:copyOne];
        numberOfItem += 1;
    }
    
    if (numberOfItem > 1) {
        theRootScrollView.contentSize = CGSizeMake(self.bounds.size.width * MaxCountOfScrollerContent * lateral_model + self.bounds.size.width * portrait_model, self.bounds.size.height * MaxCountOfScrollerContent * portrait_model + lateral_model * self.bounds.size.height);
        theRootScrollView.contentOffset = CGPointMake(self.bounds.size.width * lateral_model, self.bounds.size.height * portrait_model);
    }
    
    [self LayOutScrollerView];
    
    if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(CycleScrollerViewRunTimer)]) {
        runTimerWithTime = [self.dataDelegate CycleScrollerViewRunTimer];
    }
    
    runtimer = [NSTimer scheduledTimerWithTimeInterval:runTimerWithTime target:self selector:@selector(runTimeToCycle) userInfo:nil repeats:YES];
    
    
    
    
}
#pragma mark - 获取基础的Scroll界面
- (SDCycleView *)GetDefineSycleView
{
    SDCycleView * one = [[SDCycleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    return one;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"我要执行错误");
    CGPoint currentPoint = scrollView.contentOffset;
    
    ScrollerViewDropDirction page = [self GetCurrentPage:currentPoint];
    switch (page) {
        case scroller_drop_cut:{
            [self PreviousContent];
            break;
        }
        case scroller_drop_add:{
            [self nextContent];
            break;
        }
        default:
            break;
    }
    isCanAutoRunCycle = true;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isCanAutoRunCycle = false;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self nextContent];
}

#pragma mark - 获取之前的滚动是add , cut
- (ScrollerViewDropDirction)GetCurrentPage:(CGPoint)point
{
    CGFloat currentX = point.x;
    CGFloat currentY = point.y;
    NSInteger page = currentX / self.bounds.size.width;
    if (self.dirction == ScrollerViewDirction_Portrait) {
        page = currentY / self.bounds.size.height;
    }
    
    if (page == 0) {
        return scroller_drop_cut;
    }else if (page == 1){
        return scroller_drop_equal;
    }else if (page == 2){
        return scroller_drop_add;
    }
    return scroller_drop_equal;
    
}


// 计算出下一页
- (void)nextContent {
    currentOfStep ++;
    currentOfStep = currentOfStep % numberOfItem;
    [theRootScrollView setContentOffset:CGPointMake(self.bounds.size.width * lateral_model, self.bounds.size.height * portrait_model)];
    [self LayOutScrollerView];
}
// 计算出上一页
- (void)PreviousContent{
    currentOfStep -- ;
    if (currentOfStep < 0 ) {
        currentOfStep = numberOfItem - 1;
    }
    [theRootScrollView setContentOffset:CGPointMake(self.bounds.size.width * lateral_model, self.bounds.size.height * portrait_model)];
    [self LayOutScrollerView];

}
#pragma mark -  重新部署界面
- (void)LayOutScrollerView
{
    SDCycleView * currentView = self.theScrollDataList[currentOfStep];
    NSInteger nextPage = (currentOfStep + 1) % numberOfItem;
    SDCycleView * nextView = self.theScrollDataList[nextPage];
    NSInteger previousPage = (currentOfStep - 1) < 0 ? numberOfItem - 1 : (currentOfStep -1);
    SDCycleView * previousView = self.theScrollDataList[previousPage];
    
    
    [currentView setFrame:CGRectMake(self.bounds.size.width * lateral_model, self.bounds.size.height * portrait_model,self.bounds.size.width,self.bounds.size.height)];
    [nextView setFrame:CGRectMake(self.bounds.size.width * 2 * lateral_model, self.bounds.size.height * 2 * portrait_model,self.bounds.size.width,self.bounds.size.height)];
    [previousView setFrame:LATERAL_PREVIOUSPAGE_contentOffset];

}
#pragma mark - 单击事件的触发
- (void)onTapScrollerView:(UIGestureRecognizer*)gesture
{
    if (self.dataDelegate&& [self.dataDelegate respondsToSelector:@selector(CycleScrollerView:didSeclectedIndexPath:)]) {
        [self.dataDelegate CycleScrollerView:self didSeclectedIndexPath:currentOfStep];
    }
}

- (void)runTimeToCycle
{
    if (isCanAutoRunCycle) {
        [theRootScrollView setContentOffset:CGPointMake(self.bounds.size.width * 2 * lateral_model , self.bounds.size.height * 2 * portrait_model) animated:true];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
