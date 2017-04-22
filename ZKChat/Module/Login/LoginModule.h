//
//  LoginModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/19.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUserEntity.h"
#import "DDTcpServer.h"
#import "DDHttpServer.h"
#import "DDMsgServer.h"

@interface LoginModule : NSObject
{
    DDHttpServer* _httpServer;
    DDMsgServer* _msgServer;
    DDTcpServer* _tcpServer;
}
@property (nonatomic,readonly)NSString* token;
+ (instancetype)instance;

/**
 *  登录接口，整个登录流程
 *
 *  @param name     用户名
 *  @param password 密码
 */
- (void)loginWithUsername:(NSString*)name password:(NSString*)password success:(void(^)(ZKUserEntity* user))success failure:(void(^)(NSString* error))failure;
/**
 *  离线
 */
- (void)offlineCompletion:(void(^)())completion;
- (void)reloginSuccess:(void(^)())success failure:(void(^)(NSString* error))failure;
@end
