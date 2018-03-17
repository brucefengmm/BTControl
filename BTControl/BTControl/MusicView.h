//
//  MusicView.h
//  BTControl
//
//  Created by bruce on 2018/3/17.
//  Copyright © 2018年 bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicView : UIViewController
@property (strong, nonatomic) IBOutlet UIProgressView *volProgressView;
- (IBAction)volLess:(id)sender;
- (IBAction)volAdd:(id)sender;

@end
