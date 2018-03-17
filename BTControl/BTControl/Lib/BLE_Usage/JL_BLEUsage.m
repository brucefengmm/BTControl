//
//  JL_BLEUsage.m
//  AiRuiSheng
//
//  Created by DFung on 2017/2/20.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "JL_BLEUsage.h"



@implementation JL_BLEUsage

static JL_BLEUsage *ME = nil;
+(id)sharedMe{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ME = [[self alloc] init];
    });
    return ME;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _bt_name        = @"";
        _btEnityList    = [NSMutableArray new];

        _JL_ble_control = [JL_BLEControl new];
        _JL_ble_core    = [JL_BLE_Core sharedMe];
        //[_JL_ble_core keepCMD_90:NO];
        
        [self addNote];
        NSLog(@"Created【 JL_BLEUsage 】.");
    }
    return self;
}



+(JL_BLEControl*)getBLEControl{
    return ME.JL_ble_control;
}

#pragma mark 监听所有事件
-(void)allNoteListen:(NSNotification*)note{
    NSString *name = note.name;
//    if ([name isEqual:kBT_RECIVE_DATA]) {
//        DLog(@"read:%@",note.object);
//    }
    /*--- JL_BLE_SDK 请求发送数据！---*/
    if ([name isEqual:kBT_SEND_DATA]) {
        NSData *bleData = [note object];
        [_JL_ble_control writeCharacterCBWBytes:bleData];
    }
    
    if ([name isEqual:kBT_DEVICES_DISCOVERED])
    {
        [_btEnityList removeAllObjects];
        NSMutableSet *peripherals = [note object];
        
        for (CBPeripheral *item in peripherals)
        {
            if ([item.name containsString:@"Kinstone"]) {
                JL_CommonEntiy *entity = [JL_CommonEntiy new];
                entity.mItem = item.name;
                entity.mPeripheral = item;
                [_btEnityList addObject:entity];
                [DFNotice post:kUI_DEVICES_DISCOVERED Object:entity];
            }
           
        }
    }
    
    if ([name isEqual:kBT_DEVICE_CONNECTED])
    {
        _bt_status_connect = YES;
        CBPeripheral *currrentPeripheral = [note object];
        
        [[NSUserDefaults standardUserDefaults] setObject:currrentPeripheral.identifier.UUIDString forKey:@"reconnect"];
        for (JL_CommonEntiy *item in _btEnityList)
        {
            item.isSelectedStatus = NO;
            if (item.mItem == currrentPeripheral.name &&
                item.mPeripheral.identifier == currrentPeripheral.identifier)
            {
                item.isSelectedStatus = YES;
                _bt_name = item.mItem;
            }
        }
        [DFNotice post:kUI_DEVICE_CONNECTED Object:_bt_name];
    }
    
    if ([name isEqual:kBT_DEVICE_DISCONNECT_SDK])
    {
        _bt_status_connect = NO;
        for (JL_CommonEntiy *item in _btEnityList){
            item.isSelectedStatus = NO;
        }
        _bt_name = @"";
        NSString *out_dev_name = [note object];
        [DFNotice post:kUI_DEVICE_DISCONNECT Object:out_dev_name];
    }
    
    if ([name isEqual:kBT_DISCONNECTED]) {
        _bt_status_phone = NO;
        for (JL_CommonEntiy *item in _btEnityList){
            item.isSelectedStatus = NO;
        }
        _bt_name = @"";
        [DFNotice post:kUI_DISCONNECTED Object:nil];
    }
    
    if ([name isEqual:kBT_CONNECTED]) {
        _bt_status_phone = YES;
        [DFNotice post:kUI_CONNECTED Object:nil];
    }
}



-(void)addNote{
    //[DFNotice add:kBT_SEND_DATA Action:@selector(noteBluetoothSend:) Own:self];
    [DFNotice add:nil Action:@selector(allNoteListen:) Own:self];
}


-(void)dealloc{
    //[DFNotice remove:kBT_SEND_DATA Own:self];
    [DFNotice remove:nil Own:self];
}


@end
