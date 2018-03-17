//
//  AppDelegate.h
//  BTControl
//
//  Created by bruce on 2018/3/3.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//curFun
#define BTCONTROL_CUR_FUNCTION_FM @"fm"
#define BTCONTROL_CUR_FUNCTION_AM @"am"
#define BTCONTROL_CUR_FUNCTION_AUX @"aux"
#define BTCONTROL_CUR_FUNCTION_BT @"bt"

//fm am 显示的button的tag起始 和 结尾
#define BTCONTROL_FM_START_TAG 1
#define BTCONTROL_FM_END_TAG   18

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *curFun;

@end

