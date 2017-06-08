//
//  TimerViewController.m
//  NSTimerDemo
//
//  Created by Randy Liu on 2017/5/24.
//  Copyright © 2017年 com.shenzhenetop.httptest. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerTools.h"

@interface TimerViewController ()
/// <#description#>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation TimerViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentHeight.constant = 1000;
   
    // 这种方式会早成内存泄漏 下面的方式则不会
    // _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printMessage) userInfo:nil repeats:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[[TimerTools alloc] initWithDelegate:self] selector:@selector(printMessage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)printMessage {
    NSLog(@"%s", __func__);
}

@end
