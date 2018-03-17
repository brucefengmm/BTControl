//
//  BTProgressView.h
//  BTControl
//
//  Created by bruce on 2018/3/11.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTProgressView : UIView
// 进度条背景图片
@property (retain, nonatomic) UIImageView *trackView;
// 进图条填充图片
@property (retain, nonatomic) UIImageView *progressView;
//进度
@property (nonatomic) CGFloat targetProgress;
//设置进度条的值
- (void)setProgress:(CGFloat)progress;

@end
