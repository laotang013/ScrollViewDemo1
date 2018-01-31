//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by Start on 2018/1/30.
//  Copyright © 2018年 Start. All rights reserved.
//

#import "ViewController.h"
#import "TPScrollView.h"
@interface ViewController ()
/**TP*/
@property(nonatomic,strong)TPScrollView *tpView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tpView = [[TPScrollView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 120)];
    self.tpView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tpView];
    self.tpView.scale = 0.4;
    self.tpView.isAnimation = YES;
    self.tpView.maxScale = 1.0f;
    self.tpView.minScale = 0.8f;
    [self.tpView startRender];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
