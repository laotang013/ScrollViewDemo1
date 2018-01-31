//
//  TPScrollView.m
//  ScrollViewDemo
//
//  Created by Start on 2018/1/30.
//  Copyright © 2018年 Start. All rights reserved.
//

#import "TPScrollView.h"
@interface TPScrollView()<UIScrollViewDelegate>
/**1.添加一个ScrollView 2.设置复用*/
@property(nonatomic,assign)CGFloat subViewWidth;//ScrollView宽度
@property(nonatomic,assign)CGPoint point;//重置位置
@property(nonatomic,assign)NSInteger index;//标记数据源位置
@property(nonatomic,assign)CGRect subFrame;
@property(nonatomic,assign)CGFloat cellNum;

@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *subViewAry;     //容器数组
@property (nonatomic,strong)NSMutableArray *reuseViewAry;   //复用池view数组
@property (nonatomic,strong)NSMutableArray *userViewAry;    //在使用view数组

/**颜色数据*/
@property(nonatomic,strong)NSArray *colorArray;
@end
@implementation TPScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.colorArray = @[[UIColor blueColor],[UIColor redColor],[UIColor grayColor],[UIColor greenColor],[UIColor orangeColor]];
    }
    return self;
}
-(void)createUI
{
    [self setupDefalut];
    [self setupSubViews];
}

#pragma mark - 初始化
-(void)setupSubViews
{
    
    self.scrollView.frame = CGRectMake((self.frame.size.width-self.subViewWidth)*0.5, 0, self.subViewWidth, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.subViewWidth*5, self.frame.size.height);
    [self.subViewAry removeAllObjects];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<5; i++) {
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(i*self.subViewWidth, 0, self.subViewWidth, self.frame.size.height)];
        subView.backgroundColor =self.colorArray[i];
        [self.scrollView addSubview:subView];
        [self.subViewAry addObject:subView];
    }
    [self addSubview:self.scrollView];
    if (self.isAnimation) {
        //全部进行缩放一遍
        for (UIView *subView in self.subViewAry) {
            subView.layer.transform = CATransform3DMakeScale(self.minScale, self.minScale, 1.0);
        }
        UIView *subView = [self.subViewAry objectAtIndex:1];
        subView.layer.transform = CATransform3DMakeScale(self.maxScale, self.maxScale, 1.0);
    }
}
/**默认值*/
-(void)setupDefalut
{
    self.subViewWidth = self.frame.size.width * self.scale;
    self.point = CGPointMake(self.subViewWidth, 0);
    self.subFrame = CGRectMake(self.marginX, 0, self.subViewWidth-self.marginX*2, self.frame.size.height);
}
/**开始渲染*/
-(void)startRender
{
    [self setupDefalut];
    [self setupSubViews];
    [self checkOffset];
}

#pragma mark - 添加ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self animation];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger contentOffSetIndex = (int)(self.scrollView.contentOffset.x / self.subViewWidth + 0.5);
    NSLog(@"滚动偏移量: %zd",contentOffSetIndex);
    if (contentOffSetIndex == 4) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    if (contentOffSetIndex == 0) {
        [self.scrollView setContentOffset:CGPointMake(4*self.subViewWidth, 0) animated:NO];
    }
}
-(void)updateConfig
{
    [self checkOffset];
}
-(void)checkOffset
{
    self.scrollView.contentOffset = self.point;
    if (self.isAnimation == NO) {
        return;
    }
    for (int i=0; i<self.subViewAry.count; i++) {
        UIView *subView = [self.subViewAry objectAtIndex:i];
        if (i==1) {
            subView.layer.transform = CATransform3DMakeScale(self.maxScale, self.maxScale, 1.0);
        }else
        {
            subView.layer.transform = CATransform3DMakeScale(self.minScale, self.minScale, 1.0);
        }
    }
}


-(void)animation
{
    if (!self.isAnimation) {
        return;
    }
    NSInteger midIndex = (self.scrollView.contentOffset.x / self.subViewWidth);
    //NSLog(@"midIndex: %zd",midIndex);
    UIView *subView = (UIView*)[self.subViewAry objectAtIndex:midIndex];
    UIView *subViewRight = (UIView*)[self.subViewAry objectAtIndex:midIndex+1];
    UIView *subViewLeft = nil;
    if (midIndex>0) {
        subViewLeft = (UIView*)[self.subViewAry objectAtIndex:midIndex-1];
    }
    CGFloat sum = self.scrollView.contentOffset.x + (self.subViewWidth)*0.5;//中线
    CGFloat centerX = subView.center.x;
    //NSLog(@"centerX: %.2f",centerX);
    CGFloat diff = sum - centerX;
    CGFloat shortX = self.subViewWidth;
    //double fabs(double i); 处理double类型的取绝对值
    if (centerX <= sum && fabs(diff) < shortX) {
        //向左滑动
        //NSLog(@"向左滑动");
        CGFloat scale = self.maxScale - fabs(diff)/shortX*(self.maxScale-self.minScale);
        subView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
        CGFloat scale1 = self.minScale+fabs(diff)/shortX*(self.maxScale-self.minScale);
        //NSLog(@"scale1: %.2f",scale1);
        subViewRight.layer.transform = CATransform3DMakeScale(scale1, scale1, 1.0);
    }
    
    if (centerX >= sum && fabs(diff)<= shortX) {
        //向右
        //NSLog(@"向右滑动");
        CGFloat scale = self.maxScale-fabs(diff)/shortX*(self.maxScale-self.minScale);
        subView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
        CGFloat scale1 = self.minScale+fabs(diff)/shortX*(self.maxScale-self.minScale);
        subViewLeft.layer.transform = CATransform3DMakeScale(scale1, scale1, 1.0);
    }
}
#pragma mark - getter&Setter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGFloat height = self.frame.size.height;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((self.frame.size.width-self.subViewWidth)/2, 0, self.subViewWidth, height)];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.layer.masksToBounds = NO;
        _scrollView.contentSize = CGSizeMake(self.subViewWidth*5, height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.decelerationRate = 0.1;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)subViewAry{
    if (!_subViewAry) {
        _subViewAry = [NSMutableArray new];
    }
    return _subViewAry;
}

- (NSMutableArray *)reuseViewAry{
    if (!_reuseViewAry) {
        _reuseViewAry = [NSMutableArray new];
    }
    return _reuseViewAry;
}

-  (NSMutableArray *)userViewAry{
    if (!_userViewAry) {
        _userViewAry = [NSMutableArray new];
    }
    return _userViewAry;
}
@end
