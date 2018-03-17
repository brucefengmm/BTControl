//
//  FmView.m
//  BTControl
//
//  Created by bruce on 2018/3/7.
//  Copyright © 2018年 bruce. All rights reserved.
//
#import "BtView.h"
#import "JL_BLEUsage.h"
#import "AppDelegate.h"

@interface BtView ()
{
    AppDelegate *delegate;
}
@end

@implementation BtView
@synthesize volProgressView;

/*
 34 91 34 91 34 91 34
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([delegate.curFun isEqualToString:BTCONTROL_CUR_FUNCTION_AUX])
    {
        self.navigationItem.title = @"AUX";
    }
    else
    {
        self.navigationItem.title = @"BT";
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    volProgressView.transform = transform;
    
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
