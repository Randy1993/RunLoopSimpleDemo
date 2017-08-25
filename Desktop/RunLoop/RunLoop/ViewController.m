//
//  ViewController.m
//  RunLoop
//
//  Created by Randy Liu on 2017/8/24.
//  Copyright © 2017年 com.shenzhenetop.httptest. All rights reserved.
//

#import "ViewController.h"

extern void instrumentObjcMessageSends(BOOL);

@interface ViewController ()<NSPortDelegate>
/// <#description#>
@property (nonatomic, strong) NSThread *thread;
/// <#description#>
@property (nonatomic, strong) NSPort *port;
/// <#description#>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   _thread = [self networkRequestThread];
}

- (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
}

- (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop]; // 这里获取的并不是mainRunloop 你要知道，这段代码实际上是在子线程中执行的
        _port = [NSMachPort port];
        _port.delegate = self;
        [runLoop addPort:_port forMode:NSDefaultRunLoopMode];
//        [runLoop run];
//        [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:MAXFLOAT]]; // 这样只会执行一次actionInThread然后失败了
        
//        [runLoop runUntilDate:[NSDate distantFuture]];
//         [runLoop run];
        
        CFRunLoopRunInMode((__bridge CFRunLoopMode)NSDefaultRunLoopMode, 100000000000, NO); // 要这样启动runloop才行，
    }
}

- (void)actionOnThread {
    NSLog(@"当前线程:%@",[NSThread currentThread]);
    NSLog(@"保存的属性线程:%@", _thread);
}

- (IBAction)actionInThread:(UIButton *)sender {
    if (_thread.isCancelled) {
        return;
    }
    [self performSelector:@selector(actionOnThread) onThread:_thread withObject:nil waitUntilDone:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        instrumentObjcMessageSends(YES); // 打印日志的一种方式，Log日志放在/private/tmp/msgSends-%d，%d是进程pid。
    });
}

- (IBAction)sendMsgToThread:(UIButton *)sender {
    NSString *s1 = @"hello";
    
    NSData *data = [s1 dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[data]];
    [_port sendBeforeDate:[NSDate date] msgid:1000 components:array from:[NSMachPort port] reserved:0];
}

- (IBAction)removePort:(UIButton *)sender {
   
}

- (void)handlePortMessage:(id)message {
    NSLog(@"收到消息了，线程为：%@",[NSThread currentThread]);
    
    //只能用KVC的方式取值
    NSArray *array = [message valueForKeyPath:@"components"];
    NSLog(@"message:%@ string :%@", array, [[NSString alloc] initWithData:array[0] encoding:NSUTF8StringEncoding]);
    
//    [[NSRunLoop currentRunLoop] removePort:_port forMode:NSDefaultRunLoopMode];
    
    CFRunLoopStop(CFRunLoopGetCurrent());
//    NSThread *thread = [NSThread currentThread];
//    [thread cancel];
    
    //    NSMachPort *localPort = [message valueForKeyPath:@"localPort"];
    //    NSMachPort *remotePort = [message valueForKeyPath:@"remotePort"];
}
@end
