//
//  RuntimeStatus.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "RuntimeStatus.h"
#import "ZKUserEntity.h"
#import "ZKUtil.h"
#import "ZKAFNetworkingClient.h"
#import "ZKConstant.h"

@implementation RuntimeStatus

+ (instancetype)instance
{
    static RuntimeStatus* g_runtimeState;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_runtimeState = [[RuntimeStatus alloc] init];
        
    });
    return g_runtimeState;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.user = [ZKUserEntity new];
        [self registerAPI];
        [self checkUpdateVersion];
    }
    return self;
}

-(void)checkUpdateVersion
{
    
    [ZKAFNetworkingClient jsonFormGETRequest:@"http://tt.mogu.io/tt/ios.json" param:nil success:^(id responseObject){

            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            double version = [responseDictionary[@"version"] doubleValue];
            [ZKUtil setDBVersion:[responseDictionary[@"dbVersion"] intValue]];
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            double app_Version = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] doubleValue];
            if (app_Version < version) {
                self.updateInfo =@{@"haveupdate":@(YES),@"url":responseDictionary[@"url"]};
            }else{
                self.updateInfo =@{@"haveupdate":@(NO),@"url":@" "};
            }
    } failure:^(NSError *error) {
        DDLog(@" %@ ",error);
    }];

    
}
-(void)registerAPI
{
//    //接收踢出
//    ReceiveKickoffAPI *receiveKick = [ReceiveKickoffAPI new];
//    [receiveKick registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:DDNotificationUserKickouted object:object];
//    }];
//    //接收签名改变通知
//    MTTSignNotifyAPI *receiveSignNotify = [MTTSignNotifyAPI new];
//    [receiveSignNotify registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:DDNotificationUserSignChanged object:object];
//    }];
//    //接收pc端登陆状态变化通知
//    MTTPCLoginStatusNotifyAPI *receivePCLoginNotify = [MTTPCLoginStatusNotifyAPI new];
//    [receivePCLoginNotify registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:DDNotificationPCLoginStatusChanged object:object];
//    }];
}

-(void)updateData
{
//    [DDMessageModule shareInstance];
//    [DDClientStateMaintenanceManager shareInstance];
//    [DDGroupModule instance];
}

@end
