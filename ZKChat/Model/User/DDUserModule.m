//
//  DDUserModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/15.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDUserModule.h"
#import "ZKConstant.h"
#import "ZKNotification.h"
#import "ZKDatabaseUtil+Users.h"


@interface DDUserModule(PrivateAPI)

- (void)n_receiveUserLogoutNotification:(NSNotification*)notification;
- (void)n_receiveUserLoginNotification:(NSNotification*)notification;
@end
@implementation DDUserModule
{
    NSMutableDictionary* _allUsers;
    NSMutableDictionary* _allUsersNick;
}


+(instancetype)shareInstance{

    static DDUserModule *ddUserModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ddUserModule =[[DDUserModule alloc]init];
        
    });
    return ddUserModule;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _allUsers = [[NSMutableDictionary alloc] init];
        _recentUsers = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(n_receiveUserLoginNotification:) name:DDNotificationUserLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(n_receiveUserLoginNotification:) name:DDNotificationUserReloginSuccess object:nil];
        
        
    }
    return self;
}
- (void)addMaintanceUser:(ZKUserEntity*)user
{
    
    if (!user)
    {
        return;
    }
    if (!_allUsers)
    {
        _allUsers = [[NSMutableDictionary alloc] init];
    }
    if(!_allUsersNick)
    {
        _allUsersNick = [[NSMutableDictionary alloc] init];
    }
    [_allUsers setValue:user forKey:user.objID];
    [_allUsersNick setValue:user forKey:user.nick];
    
}
-(NSArray *)getAllUsersNick
{
    return [_allUsersNick allKeys];
}
-(ZKUserEntity *)getUserByNick:(NSString *)nickName
{
    //    NSInteger index = [[self getAllUsersNick] indexOfObject:nickName];
    return [_allUsersNick objectForKey:nickName];
}
-(NSArray *)getAllMaintanceUser
{
    return [_allUsers allValues];
}
- (void )getUserForUserID:(NSString*)userID Block:(void(^)(ZKUserEntity *user))block
{
    return block(_allUsers[userID]);
    
}

- (void)addRecentUser:(ZKUserEntity*)user
{
    if (!user)
    {
        return;
    }
    if (!self.recentUsers)
    {
        self.recentUsers = [[NSMutableDictionary alloc] init];
    }
    NSArray* allKeys = [self.recentUsers allKeys];
    if (![allKeys containsObject:user.objID])
    {
        [self.recentUsers setValue:user forKey:user.objID];
        [[ZKDatabaseUtil instance] insertUsers:@[user] completion:^(NSError *error) {
            
        }];
    }
    
}
-(void)clearRecentUser
{
    DDUserModule* userModule = [DDUserModule shareInstance];
    [[userModule recentUsers] removeAllObjects];
}
- (void)loadAllRecentUsers:(DDLoadRecentUsersCompletion)completion
{
    
    //加载本地最近联系人
}
#pragma mark PrivateAPI

- (void)n_receiveUserLogoutNotification:(NSNotification*)notification
{
    //用户登出
    _recentUsers = nil;
}

- (void)n_receiveUserLoginNotification:(NSNotification*)notification
{
    if (!_recentUsers)
    {
        _recentUsers = [[NSMutableDictionary alloc] init];
        [self loadAllRecentUsers:^{
            [ZKNotification postNotification:DDNotificationRecentContactsUpdate userInfo:nil object:nil];
        }];
    }
}
@end
