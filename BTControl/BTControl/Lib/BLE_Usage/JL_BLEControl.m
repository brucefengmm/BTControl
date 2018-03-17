//
//  JL_BLEControl.m
//  AiRuiSheng
//
//  Created by DFung on 2017/2/16.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <DFUnits/DFUnits.h>
#import <JL_BLE/JL_BLE.h>
#import "JL_BLEControl.h"

static NSString *BLE_BOX_SERVICE    = @"AE00";//="AE00"//text service uuid
static NSString *BOX_NOTIFY_CHARTER = @"AE02";//="AE02" //text notify charter uuid
static NSString *BOX_WRITE_CHARTER  = @"AE01";//="AE01" //text write outof respond and read charter uuid
static int DEFINITED_LENGTH_BY_JL   = 45;

static BabyBluetooth    *bleShareInstance;
static NSMutableSet     *peripherallist;
static NSMutableArray   *servicelist;
static NSMutableArray   *characterlist;
static CBCharacteristic *readCharacter;
static CBCharacteristic *writeCharacter;
static int recvIndex = 0;



@interface JL_BLEControl (){

@public
    CBPeripheral *currentConnectedPeripheral;
}

@end


@implementation JL_BLEControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        bleShareInstance = [BabyBluetooth shareBabyBluetooth];
        [self bleScanDelegate];
        //NSLog(@"-------------> JL_BLEControl");
    }
    return self;
}


-(void)stopScanBLE{
    [bleShareInstance cancelScan];
}

-(void)startScanBLE{
    peripherallist = [NSMutableSet new];
    [bleShareInstance scanForPeripherals];
    [bleShareInstance begin];
}

-(void)connectBLE:(CBPeripheral*)peripheral{
    if (peripherallist.count <= 0) return;

    for (CBPeripheral *item in peripherallist) {
        if (item.identifier == peripheral.identifier)
        {
            currentConnectedPeripheral = peripheral;
            self.currentPeripheral = peripheral;
            BabyBluetooth *bt = [bleShareInstance having:currentConnectedPeripheral];
            bt = [bt discoverServices];
            bt = [bt discoverCharacteristics];
            [bt begin];
            NSLog(@"Connecting... Device Name ----> %@",peripheral.name);
        }
    }
}

-(void)disconnectBLE{
    [bleShareInstance cancelAllPeripheralsConnection];
}





-(void)writeBytes:(NSData*)bytes{
    NSInteger len = bytes.length;
    NSData *data = bytes;
    
    while (len>0) {
        if (len == 0) break;
        
        if (len <= 45) {
            [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, data.length)]
                                 forCharacteristic:writeCharacter
                                              type:CBCharacteristicWriteWithoutResponse];
            len -= data.length;
        }else{
            [currentConnectedPeripheral writeValue:[data subdataWithRange:NSMakeRange(0, DEFINITED_LENGTH_BY_JL)]
                                 forCharacteristic:writeCharacter
                                              type:CBCharacteristicWriteWithoutResponse];
            len -= DEFINITED_LENGTH_BY_JL;
            data = [data subdataWithRange:NSMakeRange(DEFINITED_LENGTH_BY_JL, len)];
        }
    }
}


-(BOOL)writeCharacterCBWBytes:(NSData*)bytes{
    if (currentConnectedPeripheral && writeCharacter) {
        [self writeBytes:bytes];
        return YES;
    }
    return NO;
}




-(BOOL)writeCharacterCSWBytes:(NSData*)bytes{
    if (currentConnectedPeripheral && writeCharacter) {
        [currentConnectedPeripheral writeValue:bytes
                             forCharacteristic:writeCharacter
                                          type:CBCharacteristicWriteWithoutResponse];
        return YES;
    }
    return NO;
}



#pragma mark 蓝牙收到数据！
-(void)setCharacterNotify{
    [bleShareInstance notify:currentConnectedPeripheral
              characteristic:readCharacter
                       block:^(CBPeripheral *peripheral,
                               CBCharacteristic *characteristics,
                               NSError *error)
     {
         if (characteristics.value == nil) return;
         [DFNotice post:kBT_RECIVE_DATA Object:characteristics.value];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reciveData" object:characteristics.value];
//         NSData *data = characteristics.value;
//         NSLog(@"蓝牙数据-----------");
//         NSLog(@"%@",data);
//         NSLog(@"------------------");
         recvIndex++;
     }];
}



#pragma mark 设置扫描代理
-(void)bleScanDelegate{
    __weak typeof(self) w_self = self;

#pragma mark -CBCentralManagerState
    [bleShareInstance setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBManagerStatePoweredOn) {
            [DFNotice post:kBT_CONNECTED Object:@"null"];
//            NSLog(@"=============================> 1");
        }
        if (central.state == CBManagerStatePoweredOff) {
            [DFNotice post:kBT_DISCONNECTED Object:@"null"];
//            NSLog(@"=============================> 2");
        }
    }];
    
#pragma mark -DiscoverToPeripheral 发现外设
    [bleShareInstance setBlockOnDiscoverToPeripherals:^(CBCentralManager *central,
                                                        CBPeripheral *peripheral,
                                                        NSDictionary *advertisementData,
                                                        NSNumber *RSSI)
    {
        NSLog(@"Discovered ----> Device : %@  (%@)",peripheral.name,peripheral.identifier.UUIDString);
        if (peripheral.name) {
            [peripherallist addObject:peripheral];
        }
        [DFNotice post:kBT_DEVICES_DISCOVERED Object:peripherallist];
    }];
    
#pragma mark -DiscoverServices 发现服务
    [bleShareInstance setBlockOnDiscoverServices:^(CBPeripheral *peripheral,
                                                   NSError *error)
    {
        for (CBService *service in peripheral.services) {
            NSLog(@"Discovered ----> Service :%@",service.UUID.UUIDString);
            [servicelist addObject:service];
        }
    }];
    
#pragma mark -DiscoverCharacteristics 发现属性／特征
    [bleShareInstance setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral,
                                                          CBService *service,
                                                          NSError *error)
    {
        for (CBCharacteristic *character in service.characteristics) {
            NSLog(@"Discovered ----> Character : %@",character.UUID.UUIDString);
            [characterlist addObject:character];
            
            if ([character.UUID.UUIDString containsString:BOX_WRITE_CHARTER]) {
                NSLog(@"BLE Get Write Channel ----> %@",character);
                writeCharacter = character;
            }
            
            if ([character.UUID.UUIDString containsString:BOX_NOTIFY_CHARTER]) {
                NSLog(@"BLE Get Read Channel ----> %@ %d",character,character.isNotifying);
                readCharacter = character;
                [w_self setCharacterNotify];
            }
        }
    }];
    
#pragma mark -DidUpdateNotificationState 更新通知特征的状态
//    __weak typeof(bleShareInstance) w_bleShareInstance = bleShareInstance;
    [bleShareInstance setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic,
                                                                              NSError *error)
    {
        if (characteristic.isNotifying) {
            [[bleShareInstance readValueForCharacteristic] begin];
            [DFNotice post:kBT_DEVICE_NOTIFY_SUCCEED_SDK  Object:@"success"];
//            NSLog(@"=============================> 3");
        }
    }];
    
#pragma mark -OnConnected 已连接
    [bleShareInstance setBlockOnConnected:^(CBCentralManager *central,
                                            CBPeripheral *peripheral)
    {
        NSLog(@"Connected ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_CONNECTED Object:peripheral];
    }];
    
    
#pragma mark -OnFailToConnect 尝试连接失败
    [bleShareInstance setBlockOnFailToConnect:^(CBCentralManager *central,
                                                CBPeripheral *peripheral,
                                                NSError *error)
    {
        NSLog(@"Fail connect ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_FAIL_CONNECT Object:peripheral.name];
    }];
    
    
#pragma mark -OnDisconnect 已断开连接
    [bleShareInstance setBlockOnDisconnect:^(CBCentralManager *central,
                                             CBPeripheral *peripheral,
                                             NSError *error)
    {
        NSLog(@"Disconnect ----> Device %@",peripheral.name);
        [DFNotice post:kBT_DEVICE_DISCONNECT_SDK Object:peripheral.name];
//        NSLog(@"=============================> 4");
    }];
    
    
#pragma mark -ReadValueForCharacteristic 读值的回调
    [bleShareInstance setBlockOnDidWriteValueForDescriptor:^(CBDescriptor *descriptor,
                                                             NSError *error)
    {
        NSLog(@"read:%@",descriptor);
    }];
    
#pragma mark -setBlockOnCancelAllPeripheralsConnectionBlock 取消所有外设
    [bleShareInstance setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager)
    {
        NSLog(@"CancelAllPeripherals Connection");
    }];
    
    
#pragma mark -setBlockOnCancelScanBlock 取消扫描
    [bleShareInstance setBlockOnCancelScanBlock:^(CBCentralManager *centralManager)
    {
        NSLog(@"Cancel Scan");
    }];

    
}

#pragma mark -Reconnect or Cancle
-(void)autoReconnect{
    [[BabyBluetooth shareBabyBluetooth] AutoReconnect:currentConnectedPeripheral];
    [[BabyBluetooth shareBabyBluetooth] AutoReconnectCancel:currentConnectedPeripheral];
}






@end
