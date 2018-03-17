//
//  fmView.h
//  BTControl
//
//  Created by bruce on 2018/3/7.
//  Copyright © 2018年 bruce. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface FmView : UIViewController
@property (strong, nonatomic) IBOutlet UIProgressView *volProgressView;
@property (strong, nonatomic) IBOutlet UIImageView *btSearchNext;
@property (strong, nonatomic) IBOutlet UIImageView *btSearchPre;
@property (strong, nonatomic) IBOutlet UILabel *freText;

@end

