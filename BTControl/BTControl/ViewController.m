//
//  ViewController.m
//  BTControl
//
//  Created by bruce on 2018/3/3.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import "ViewController.h"
#import "JL_BLEUsage.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    JL_BLEUsage     *JL_ug;
    JL_BLEControl   *bleCtrl;
    NSMutableArray  *btEnityList;
    AppDelegate     *delegate;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Main";
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
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
    //NSLog(@"observerUINote name :%@",name);
    
    if([name isEqual:kBT_RECIVE_DATA])
    {
        //NSLog(@"%@",[note object]);
    }
    if([name isEqual:kBT_SEND_DATA])
    {
//        NSLog(@"kBT_SEND_DATA:%@",[note object]);
    }
    
     if([name isEqual:kCMD_MODE_CHANGE])
     {
         NSLog(@"kCMD_MODE_CHANGE");
     }
    
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

/*--- 模式切换 ---/
 *  "bt_case.app"   = 0;
 *  "light.app"     = 2;
 *  "linein.app"    = 4;
 *  "music.app"     = 1;
 *  "radio.app"     = 3;
 *  "udisk.app"     = 5;
 */
- (IBAction)btnFM:(id)sender {
        delegate.curFun =BTCONTROL_CUR_FUNCTION_FM;
    NSLog(@"cmdVersion:%u,ModeInfo:%u",[JL_BLE_Cmd cmdVersion],[JL_BLE_Cmd cmdModeInfo]);
//    [JL_]
//    if([JL_BLE_Cmd cmdModeInfo]==0)
//    {
//        [JL_BLE_Cmd cmdModeChange:1];
//    }
//    else
//    {
//        [JL_BLE_Cmd cmdModeChange:0];
//    }
//            [JL_BLE_Cmd cmdModeChange:(uint8_t)0x01];
    // [JL_BLE_Cmd cmdVolumeOP:0x83 Value:0x0c];
    
    Byte src[] = {0x4B, 0x54, 0x03, 0x02, 0x00, 0x06, 0xEA, 0x1D};
    NSData *data = [NSData dataWithBytes:src length:8];
    [bleCtrl writeCharacterCBWBytes:data];
}

- (IBAction)btnAM:(id)sender {
    delegate.curFun =BTCONTROL_CUR_FUNCTION_AM;
}

- (IBAction)btnDISC:(id)sender {
    [self noSupportAlert];
}

- (IBAction)btnUSB:(id)sender {

}

- (IBAction)btnPOWER:(id)sender {
}

- (IBAction)btnSD:(id)sender {
    [self noSupportAlert];
}

- (IBAction)btnAUX:(id)sender {
    delegate.curFun =BTCONTROL_CUR_FUNCTION_AUX;
}

- (IBAction)btnBT:(id)sender {
    delegate.curFun =BTCONTROL_CUR_FUNCTION_BT;
}

- (IBAction)btnSETTING:(id)sender {
}


-(void)noSupportAlert
{
    UIAlertController *autoAlert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"该功能暂不支持!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    
    [autoAlert addAction:cancelAction];
    [self presentViewController:autoAlert animated:YES completion:nil];
}
@end
