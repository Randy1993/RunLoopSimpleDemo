//
//  ATool.m
//  NSTimerDemo
//
//  Created by Randy Liu on 2017/6/7.
//  Copyright © 2017年 com.shenzhenetop.httptest. All rights reserved.
//

#import "ATool.h"
#import "BTool.h"
#import "CTool.h"

@implementation ATool

- (id)forwardingTargetForSelector:(SEL)aSelector {
    static BTool *bTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      bTool = [[BTool alloc] init];
    });
    
    if ([bTool respondsToSelector:aSelector]) {
        return bTool;
    } else {
        return [[CTool alloc] init];
    }
}

@end
