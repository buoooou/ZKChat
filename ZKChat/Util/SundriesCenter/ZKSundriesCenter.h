//
//  ZKSundriesCenter.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZKTask)();
@interface ZKSundriesCenter : NSObject

@property (nonatomic,readonly)dispatch_queue_t serialQueue;
@property (nonatomic,readonly)dispatch_queue_t parallelQueue;

+ (instancetype)instance;
- (void)pushTaskToSerialQueue:(ZKTask)task;

@end
