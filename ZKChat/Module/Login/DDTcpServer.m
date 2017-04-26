//
//  DDTcpServer.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDTcpServer.h"
#import "ZKConstant.h"
#import "DDTcpClientManager.h"

static NSInteger timeoutInterval = 10;

@interface DDTcpServer(notification)

- (void)n_receiveTcpLinkConnectCompleteNotification:(NSNotification*)notification;
- (void)n_receiveTcpLinkConnectFailureNotification:(NSNotification*)notification;

@end

@implementation DDTcpServer
{
    ClientSuccess _success;
    ClientFailure _failure;
    BOOL _connecting;
    NSUInteger _connectTimes;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _connecting = NO;
        _connectTimes = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveTcpLinkConnectCompleteNotification:)
                                                     name:DDNotificationTcpLinkConnectComplete
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveTcpLinkConnectFailureNotification:)
                                                     name:DDNotificationTcpLinkConnectFailure
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDNotificationTcpLinkConnectComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDNotificationTcpLinkConnectFailure object:nil];
}

- (void)loginTcpServerIP:(NSString*)ip port:(NSInteger)point Success:(void(^)())success failure:(void(^)())failure
{
    if (!_connecting)
    {
        _connectTimes ++;
        _connecting = YES;
        _success = [success copy];
        _failure = [failure copy];

        [[DDTcpClientManager instance] disconnect];
        [[DDTcpClientManager instance] connect:ip port:point status:1];
        //超时处理
        NSUInteger nowTimes = _connectTimes;
        double delayInSeconds = timeoutInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (_connecting && nowTimes == _connectTimes)
            {
                _connecting = NO;
                _failure(nil);
            }
        });
    }
}


#pragma mark - notification
- (void)n_receiveTcpLinkConnectCompleteNotification:(NSNotification*)notification
{
    if(_connecting)
    {
        _connecting = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            _success();
        });
    }
    
}

- (void)n_receiveTcpLinkConnectFailureNotification:(NSNotification*)notification
{
    if (_connecting)
    {
        _connecting = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            _failure(nil);
        });
    }
}

@end
