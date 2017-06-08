//
//  TimerTools.m
//  NSTimerDemo
//
//  Created by Randy Liu on 2017/5/24.
//  Copyright © 2017年 com.shenzhenetop.httptest. All rights reserved.
//

#import "TimerTools.h"


@interface TimerTools()

/// weak 引用delegate
@property (nonatomic, weak) id delegate;

@end

@implementation TimerTools

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _delegate;
}

@end
