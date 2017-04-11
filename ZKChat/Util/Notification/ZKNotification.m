//
//  ZKNotification.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/9.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKNotification.h"

@implementation ZKNotification
+ (void)postNotification:(NSString*)notification userInfo:(NSDictionary*)userInfo object:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:object userInfo:userInfo];
    });
}
@end
