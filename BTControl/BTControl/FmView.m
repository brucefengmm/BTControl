//
//  FmView.m
//  BTControl
//
//  Created by bruce on 2018/3/7.
//  Copyright © 2018年 bruce. All rights reserved.
//
#import "FmView.h"
#import "JL_BLEUsage.h"
#import "AppDelegate.h"

@interface FmView ()
{
    AppDelegate *delegate;
    NSMutableDictionary *fmAllDict;
    NSMutableArray *fmFMTFArray;
    NSMutableArray *fmFMCPArray;
    NSMutableArray *fmFMCFArray;
}
@end

@implementation FmView
@synthesize volProgressView;
@synthesize btSearchPre;
@synthesize btSearchNext;
@synthesize freText;

/*
 34 91 34 91 34 91 34
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([delegate.curFun isEqualToString:BTCONTROL_CUR_FUNCTION_FM])
    {
        self.navigationItem.title = @"FM";
    }
    else
    {
        self.navigationItem.title = @"AM";
    }
    [self cleanFmShowWave];
    
    //声音的进度条放大
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    volProgressView.transform = transform;
    
    
    btSearchNext.userInteractionEnabled = YES;
    btSearchPre.userInteractionEnabled = YES;
    [self fmAddNote];
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"从相册选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch view] == btSearchNext)
    {
        //do some method.....
        NSLog(@"btSearchNext");
        /**
         * FM功能，频道搜索。
         *  cmd: 0x00(全频搜索)
         *       0x01(向上搜索)
         *       0x02(向下搜索)
         */
        [JL_BLE_Cmd cmdFMSearch:(uint8_t)0x02];
    }
    
    if ([touch view] == btSearchPre)
    {
        //do some method.....
        NSLog(@"btSearchPre");
        [JL_BLE_Cmd cmdFMSearch:(uint8_t)0x01];
    }
}

//设置所有控件的状态
-(void)cleanFmShowWave
{
    for (id objInput in [self.view subviews]) {
        if ([objInput isKindOfClass:[UIButton class]]) {
            UIButton *buttonTemp = objInput;
            NSInteger curTag = [buttonTemp tag];
            if(curTag>= BTCONTROL_FM_START_TAG && curTag<= BTCONTROL_FM_END_TAG)
            {
                [buttonTemp setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}

//设置fm 调频的值
-(void)setFmWave:(NSMutableArray *) fmWaveArray
{
    int i;
    for(i=0;i<fmWaveArray.count;i++)
    {
        for (id objInput in [self.view subviews]) {
            if ([objInput isKindOfClass:[UIButton class]]) {
                UIButton *buttonTemp = objInput;
                NSInteger curTag = [buttonTemp tag];
                if((curTag-1)==i)
                {
                    //                    NSLog(@"fmWaveArray.count :%ld,curtag:%d",(long)fmWaveArray.count,curTag);
                    NSNumber *wave = fmWaveArray[i][1];
                    if([delegate.curFun isEqualToString:BTCONTROL_CUR_FUNCTION_FM])
                    {
                        float waveFloat = [wave floatValue]/10;
                        [buttonTemp setTitle:[NSString stringWithFormat:@"%0.1f",waveFloat] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [buttonTemp setTitle:[wave stringValue] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

-(void)fmObserverUINote:(NSNotification*)note{
    NSString *name = note.name;
    //    NSLog(@"observerUINote name :%@",name);
    if([name isEqual:kCMD_FM_ST])
    {
        fmAllDict = [[NSMutableDictionary alloc] initWithDictionary:[note object] copyItems:YES];
       
        if([fmAllDict valueForKey:@"FMTF"] != nil)
        {
            fmFMTFArray = [[NSMutableArray alloc] initWithArray:[fmAllDict valueForKey:@"FMTF"] copyItems:YES];
            [self setFmWave:fmFMTFArray];
        }
        
    }
    
}

-(void)fmAddNote{
    [DFNotice add:kCMD_FM_ST Action:@selector(fmObserverUINote:) Own:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
