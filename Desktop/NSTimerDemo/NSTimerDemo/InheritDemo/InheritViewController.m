//
//  InheritViewController.m
//  NSTimerDemo
//
//  Created by Randy Liu on 2017/6/7.
//  Copyright © 2017年 com.shenzhenetop.httptest. All rights reserved.
//

#import "InheritViewController.h"
#import "ATool.h"

@interface InheritViewController ()

@end

@implementation InheritViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ATool *aTool = [[ATool alloc] init];
    [aTool dance];
    [aTool sing];
}

@end
