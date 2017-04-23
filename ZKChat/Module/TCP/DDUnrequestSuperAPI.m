//
//  DDUnrequestSuperAPI.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDUnrequestSuperAPI.h"
#import "DDAPISchedule.h"

@implementation DDUnrequestSuperAPI
- (BOOL)registerAPIInAPIScheduleReceiveData:(ReceiveData)received
{
    BOOL registerSuccess = [[DDAPISchedule instance] registerUnrequestAPI:(id<DDAPIUnrequestScheduleProtocol>)self];
    if (registerSuccess)
    {
        self.receivedData = received;
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
