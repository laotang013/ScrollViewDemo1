//
//  TPScrollView.h
//  ScrollViewDemo
//
//  Created by Start on 2018/1/30.
//  Copyright © 2018年 Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPScrollView : UIView
/**scrollView 的Scale 所占比例*/
@property(nonatomic,assign)CGFloat scale;
/**ScrollView左右两边的间距*/
@property(nonatomic,assign)CGFloat marginX;
/**是否缩放*/
@property(nonatomic,assign)BOOL isAnimation;
/**最小缩放值*/
@property(nonatomic,assign)CGFloat minScale;
/**最大缩放值*/
@property(nonatomic,assign)CGFloat maxScale;
/**是否循环轮播*/
@property(nonatomic,assign)BOOL isEnableMargin;
/**传递进来的数组*/
@property(nonatomic,strong)NSArray *scrollViewDataArray;


/**开始渲染*/
-(void)startRender;

@end
