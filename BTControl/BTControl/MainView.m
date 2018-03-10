//
//  ViewController.m
//  BTControl
//
//  Created by bruce on 2018/3/3.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "MainView.h"
#import "JL_BLEUsage.h"

@interface MainView ()
{
    JL_BLEUsage     *JL_ug;
    JL_BLEControl   *bleCtrl;
    NSMutableArray  *btEnityList;
}

@end

@implementation MainView


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Main";
    
    JL_ug = [JL_BLEUsage sharedMe];
    
    btEnityList = JL_ug.btEnityList;
    bleCtrl = JL_ug.JL_ble_control;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
