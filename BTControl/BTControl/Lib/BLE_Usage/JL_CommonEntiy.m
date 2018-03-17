//
//  JL_CommonEntiy.m
//  AiRuiSheng
//
//  Created by DFung on 2017/2/20.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import "JL_CommonEntiy.h"

@implementation JL_CommonEntiy

-(JL_CommonEntiy*)initValue:(NSString*)item{
    
    self = [super init];
    if (self) {
        _mItem = @"";
        _mIndex = 0;
        _isSelectedStatus = NO;
    }
    return self;

}
-(JL_CommonEntiy*)initValue:(NSString*)item IsSelected:(BOOL)isSelected{

    self = [super init];
    if (self) {
        _mItem = @"";
        _mIndex = 0;
        _isSelectedStatus = NO;
    }
    return self;

}

@end
