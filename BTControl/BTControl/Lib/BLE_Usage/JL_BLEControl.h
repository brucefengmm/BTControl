//
//  JL_BLEControl.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"


#define kBT_DEVICE_FAIL_CONNECT     @"BT_DEVICE_FAIL_CONNECT"
#define kBT_DEVICES_DISCOVERED      @"BT_DEVICES_DISCOVERED"
#define kBT_DEVICE_CONNECTED        @"BT_DEVICE_CONNECTED"
#define kBT_DISCONNECTED            @"BT_DISCONNECTED"
#define kBT_CONNECTED               @"BT_CONNECTED"

#define kBT_RECIVE_DATA             @"BT_RECIVE_DATA"
#define kBT_SEND_DATA               @"BT_SEND_DATA"



static uint8_t  PATH_TYPE_FOLDER    = 0;
static uint8_t  PATH_TYPE_FILE      = 1;

@interface JL_BLEControl : NSObject

@property (strong, nonatomic) CBPeripheral *currentPeripheral;
-(void)stopScanBLE;
-(void)startScanBLE;
-(void)connectBLE:(CBPeripheral*)peripheral;
-(void)disconnectBLE;

-(BOOL)writeCharacterCBWBytes:(NSData*)bytes;//是真正的发送给固件数据的接口
-(BOOL)writeCharacterCSWBytes:(NSData*)bytes;


@end
