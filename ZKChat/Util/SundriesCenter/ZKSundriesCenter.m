//
//  ZKSundriesCenter.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKSundriesCenter.h"

@implementation ZKSundriesCenter
+ (instancetype)instance
{
    static ZKSundriesCenter* g_ZKSundriesCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_ZKSundriesCenter = [[ZKSundriesCenter alloc] init];
    });
    return g_ZKSundriesCenter;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _serialQueue = dispatch_queue_create("com.kafeihu.SundriesSerial", NULL);
        _parallelQueue = dispatch_queue_create("com.kafeihu.SundriesParallel", NULL);
    }
    return self;
}
- (void)pushTaskToSerialQueue:(ZKTask)task
{
    dispatch_async(self.serialQueue, ^{
        task();
    });
}

@end
