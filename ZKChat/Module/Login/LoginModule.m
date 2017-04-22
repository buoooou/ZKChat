//
//  LoginModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/19.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "LoginModule.h"

@interface LoginModule(privateAPI)

- (void)p_loadAfterHttpServerWithToken:(NSString*)token userID:(NSString*)userID dao:(NSString*)dao password:(NSString*)password uname:(NSString*)uname success:(void(^)(ZKUserEntity* loginedUser))success failure:(void(^)(NSString* error))failure;
- (void)reloginAllFlowSuccess:(void(^)())success failure:(void(^)())failure;

@end
@implementation LoginModule
{
    NSString* _lastLoginUser;       //最后登录的用户ID
    NSString* _lastLoginPassword;
    NSString* _lastLoginUserName;
    NSString* _dao;
    NSString * _priorIP;
    NSInteger _port;
    BOOL _relogining;
}
+(instancetype) instance{
    static LoginModule *loginModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModule=[[LoginModule alloc]init];
    });
    return loginModule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _httpServer = [[DDHttpServer alloc] init];
        _msgServer = [[DDMsgServer alloc] init];
        _tcpServer = [[DDTcpServer alloc] init];
        _relogining = NO;
    }
    return self;
}


@end
