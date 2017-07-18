//
//  ViewController.m
//  XWLoopScrollView
//
//  Created by 向尉 on 2017/7/17.
//  Copyright © 2017年 向尉. All rights reserved.
//

#import "ViewController.h"
#import "XWLoopScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    XWLoopScrollView *loopScrollView=[[XWLoopScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) images:@[[UIImage imageNamed:@"trash.png"],[UIImage imageNamed:@"stars.jpeg"],[UIImage imageNamed:@"Pai.png"],[UIImage imageNamed:@"IMG_1022.JPG"]]];
    [self.view addSubview:loopScrollView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
