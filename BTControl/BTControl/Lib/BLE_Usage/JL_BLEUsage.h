//
//  JL_BLEUsage.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/20.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <DFUnits/DFUnits.h>
#import <JL_BLE/JL_BLE.h>

#import "JL_BLEControl.h"
#import "JL_CommonEntiy.h"

#define kCLOSE_VC                   @"CLOSE_VC"

#define kUI_DEVICES_DISCOVERED      @"UI_DEVICES_DISCOVERED"
#define kUI_DEVICE_CONNECTED        @"UI_DEVICE_CONNECTED"
#define kUI_DEVICE_DISCONNECT       @"UI_DEVICE_DISCONNECT"
#define kUI_DISCONNECTED            @"UI_DISCONNECTED"
#define kUI_CONNECTED               @"UI_CONNECTED"


@interface JL_BLEUsage : NSObject

@property(nonatomic,strong)JL_BLEControl    *JL_ble_control;
@property(nonatomic,strong)JL_BLE_Core      *JL_ble_core;

@property(nonatomic,assign)BOOL             bt_status_phone;
@property(nonatomic,assign)BOOL             bt_status_connect;

@property(nonatomic,strong)NSMutableArray   *btEnityList;
@property(nonatomic,strong)NSString         *bt_name;


+(id)sharedMe;
+(JL_BLEControl*)getBLEControl;


@end
