//
//  FmView.m
//  BTControl
//
//  Created by bruce on 2018/3/7.
//  Copyright © 2018年 bruce. All rights reserved.
//
#import "FmView.h"
#import "JL_BLEUsage.h"

@interface FmView ()
{
    UIButton *btn1;
}
@end

@implementation FmView
/*
 34 91 34 91 34 91 34
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"FM";
    
    UIImage *btn_small_normal = [UIImage imageNamed:@"btn_small_normal.png"];
    UIImage *btn_small_selected = [UIImage imageNamed:@"btn_small_select.png"];
    
    
    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(25, 168, 95, 91)];
    
    [btn1 setTitle:@"sdfdsfd" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:btn_small_normal forState:UIControlStateNormal];
    [btn1 setBackgroundImage:btn_small_selected forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(btn1_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}

-(void)btn1_click:(id)sender{
    NSLog(@"btn被点击了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
