//
//  MusicView.m
//  BTControl
//
//  Created by bruce on 2018/3/17.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "MusicView.h"
#import "JL_BLEUsage.h"
#import "AppDelegate.h"

@interface MusicView ()
{
    AppDelegate *delegate;
}
@end

@implementation MusicView
@synthesize volProgressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//    if([delegate.curFun isEqualToString:BTCONTROL_CUR_FUNCTION_AUX])
//    {
//        self.navigationItem.title = @"AUX";
//    }
//    else
//    {
//        self.navigationItem.title = @"BT";
//    }
    self.navigationItem.title = @"MUSIC";
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    volProgressView.transform = transform;
    
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)volLess:(id)sender {
    //设置进度条的进度值
    //范围从0~1，最小值为0，最大值为1.
    //0.8-->进度的80%
    NSLog(@"%f",volProgressView.progress);
    volProgressView.progress-=0.1;
    NSLog(@"%f",volProgressView.progress);
}

- (IBAction)volAdd:(id)sender {
    volProgressView.progress+=0.1;
}
@end
