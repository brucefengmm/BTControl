//
//  JL_CommonEntiy.h
//  AiRuiSheng
//
//  Created by DFung on 2017/2/20.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"

@interface JL_CommonEntiy : NSObject

@property(strong,nonatomic)NSString       *mItem;
@property(assign,nonatomic)int            mIndex;
@property(assign,nonatomic)BOOL           isSelectedStatus;
@property(strong,nonatomic)CBPeripheral   *mPeripheral;


-(JL_CommonEntiy*)initValue:(NSString*)item;
-(JL_CommonEntiy*)initValue:(NSString*)item IsSelected:(BOOL)isSelected;



@end
