//
//  ViewController.m
//  BTControl
//
//  Created by bruce on 2018/3/3.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "ViewController.h"
#import "JL_BLEUsage.h"

@interface ViewController ()
{
    JL_BLEUsage     *JL_ug;
    JL_BLEControl   *bleCtrl;
    NSMutableArray  *btEnityList;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Main";
    
    JL_ug = [JL_BLEUsage sharedMe];
    
    btEnityList = JL_ug.btEnityList;
    bleCtrl = JL_ug.JL_ble_control;
    
    [self addNote];
    [bleCtrl startScanBLE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)observerUINote:(NSNotification*)note{
    NSString *name = note.name;
    NSLog(@"observerUINote name :%@",name);
    
    if ([name isEqual:kBT_DEVICES_DISCOVERED])
    {
        [btEnityList removeAllObjects];
        NSMutableSet *peripherals = [note object];
        
        for (CBPeripheral *item in peripherals)
        {
            JL_CommonEntiy *entity = [JL_CommonEntiy new];
            entity.mItem = item.name;
            entity.mPeripheral = item;
            [btEnityList addObject:entity];
            //[mTableView reloadData];可以选择刷新列表UI
            NSLog(@"entity.mPeripheral.name : %@",entity.mPeripheral.name);
            if([entity.mPeripheral.name isEqualToString:@"BLE_NAME"])
            {
                [bleCtrl connectBLE:entity.mPeripheral];
                [bleCtrl stopScanBLE];
            }
        }
        //            [self endLoadingView];
        
        NSLog(@"btEnityList :%@",btEnityList);
    }
    
    if ([name isEqual:kBT_DEVICE_CONNECTED])
    {
        JL_ug.bt_status_connect = YES;
        CBPeripheral *currrentPeripheral = [note object];
        
        
        for (JL_CommonEntiy *item in btEnityList)
        {
            item.isSelectedStatus = NO;
            if (item.mItem == currrentPeripheral.name &&
                item.mPeripheral.identifier ==
                currrentPeripheral.identifier)
            {
                item.isSelectedStatus = YES;
                /*---提示已连接设备---*/
                NSString *name = [NSString stringWithFormat:@"已连接%@",item.mItem];
                NSLog(@"****%@",name);
            }
        }
    }
    
    if ([name isEqual:kBT_DEVICE_DISCONNECT_SDK])
    {
        JL_ug.bt_status_connect = NO;
        for (JL_CommonEntiy *item in btEnityList)
        {
            item.isSelectedStatus = NO;
        }
        //[mTableView reloadData];        UI
        NSString *out_dev_name = [note object];
        NSString *name =[NSString stringWithFormat:@"%@ 已断开.",out_dev_name];
        NSLog(@"****%@",name);
    }
    
    
    if ([name isEqual:kBT_DISCONNECTED]) {
        JL_ug.bt_status_phone = NO;
        for (JL_CommonEntiy *item in btEnityList)
        {
            item.isSelectedStatus = NO;
        }
        //[mTableView reloadData];可以选择刷新列表UI
    }
    if ([name isEqual:kBT_CONNECTED]) {
        JL_ug.bt_status_phone = YES;
    }
   
}

                              
                              
-(void)addNote{
    [DFNotice add:nil Action:@selector(observerUINote:) Own:self];
    //[DFNotice add:kCLOSE_VC Action:@selector(dismissThisVC_1:) Own:self];
}
-(void)dealloc{
    [DFNotice remove:nil Own:self];
    [DFNotice remove:kCLOSE_VC Own:self];
}
@end
