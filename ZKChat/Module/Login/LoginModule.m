//
//  LoginModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/19.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "LoginModule.h"
#import "ZKUtil.h"
#import "ZKDatabaseUtil.h"
#import "RuntimeStatus.h"
#import "DDGroupModule.h"
#import "DDUserModule.h"
#import "ZKNotification.h"
#import "ZKConstant.h"
#import "DDAllUserAPI.h"
#import "SpellLibrary.h"

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
#pragma mark Public API
- (void)loginWithUsername:(NSString*)name password:(NSString*)password success:(void(^)(ZKUserEntity* loginedUser))success failure:(void(^)(NSString* error))failure
{
    
    [_httpServer getMsgIp:^(NSDictionary *dic) {
        NSInteger code  = [[dic objectForKey:@"code"] integerValue];
        if (code == 0) {
            _priorIP = [dic objectForKey:@"priorIP"];
            _port    =  [[dic objectForKey:@"port"] integerValue];
            [ZKUtil setMsfsUrl:[dic objectForKey:@"msfsPrior"]];
            [_tcpServer loginTcpServerIP:_priorIP port:_port Success:^{
                [_msgServer checkUserID:name Pwd:password token:@"" success:^(id object) {
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autologin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    _lastLoginPassword=password;
                    _lastLoginUserName=name;
//                    DDClientState* clientState = [DDClientState shareInstance];
//                    clientState.userState=DDUserOnline;
                    _relogining=YES;
                    ZKUserEntity* user = object[@"user"];
                    TheRuntime.user=user;
                    
                    [[ZKDatabaseUtil instance] openCurrentUserDB];
                    
                    //加载所有人信息，创建检索拼音
                    [self p_loadAllUsersCompletion:^{
                        
                        if ([[SpellLibrary instance] isEmpty]) {
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [[[DDUserModule shareInstance] getAllMaintanceUser] enumerateObjectsUsingBlock:^(ZKUserEntity *obj, NSUInteger idx, BOOL *stop) {
                                    [[SpellLibrary instance] addSpellForObject:obj];
                                    //
                                }];
                                NSArray *array =  [[DDGroupModule instance] getAllGroups];
                                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    [[SpellLibrary instance] addSpellForObject:obj];
                                }];
                            });
                        }
                    }];
                    
                    //
                   // [[SessionModule instance] loadLocalSession:^(bool isok) {}];
                    //
                    success(user);
                    //
                    [ZKNotification postNotification:DDNotificationUserLoginSuccess userInfo:nil object:user];
                    
                } failure:^(NSError *object) {
                    
                    DDLog(@"login#登录验证失败");
                    
                    failure(object.domain);
                }];
                
            } failure:^{
                DDLog(@"连接消息服务器失败");
                failure(@"连接消息服务器失败");
            }];
        }
    } failure:^(NSString *error) {
        failure(@"连接消息服务器失败");
    }];
    
}

- (void)reloginSuccess:(void(^)())success failure:(void(^)(NSString* error))failure
{
    DDLog(@"relogin fun");
   // if ([DDClientState shareInstance].userState == DDUserOffLine && _lastLoginPassword && _lastLoginUserName) {
        
        [self loginWithUsername:_lastLoginUserName password:_lastLoginPassword success:^(ZKUserEntity *user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloginSuccess" object:nil];
            success(YES);
        } failure:^(NSString *error) {
            failure(@"重新登陆失败");
        }];
        
    //}
}

- (void)offlineCompletion:(void(^)())completion
{
    completion();
}
/**
 *  登录成功后获取所有用户
 *
 *  @param completion 异步执行的block
 */
- (void)p_loadAllUsersCompletion:(void(^)())completion
{
    __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    __block NSInteger version = [[defaults objectForKey:@"alllastupdatetime"] integerValue];
    [[ZKDatabaseUtil instance] getAllUsers:^(NSArray *contacts, NSError *error) {
        if ([contacts count] !=0) {
            [contacts enumerateObjectsUsingBlock:^(ZKUserEntity *obj, NSUInteger idx, BOOL *stop) {
                [[DDUserModule shareInstance] addMaintanceUser:obj];
            }];
            if (completion !=nil) {
                completion();
            }
        }else{
            version=0;
            DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
            [api requestWithObject:@[@(version)] Completion:^(id response, NSError *error) {
                if (!error)
                {
                    NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
                    if (responseVersion == version && responseVersion !=0) {
                        
                        return ;
                        
                    }
                    [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
                    NSMutableArray *array = [response objectForKey:@"userlist"];
                    [[ZKDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
                        
                    }];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [array enumerateObjectsUsingBlock:^(ZKUserEntity *obj, NSUInteger idx, BOOL *stop) {
                            [[DDUserModule shareInstance] addMaintanceUser:obj];
                        }];
                        
                        dispatch_async(dispatch_get_main_queue(),^{
                            if (completion !=nil) {
                                completion();
                            }
                        });
                        
                    });
                    
                    
                }
            }];
        }
    }];
    
    DDAllUserAPI* api = [[DDAllUserAPI alloc] init];
    [api requestWithObject:@[@(version)] Completion:^(id response, NSError *error) {
        if (!error)
        {
            NSUInteger responseVersion = [[response objectForKey:@"alllastupdatetime"] integerValue];
            if (responseVersion == version && responseVersion !=0) {
                
                return ;
                
            }
            [defaults setObject:@(responseVersion) forKey:@"alllastupdatetime"];
            NSMutableArray *array = [response objectForKey:@"userlist"];
            [[ZKDatabaseUtil instance] insertAllUser:array completion:^(NSError *error) {
                
            }];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [array enumerateObjectsUsingBlock:^(ZKUserEntity *obj, NSUInteger idx, BOOL *stop) {
                    [[DDUserModule shareInstance] addMaintanceUser:obj];
                }];
            });
            
            
        }
    }];
    
}


@end
