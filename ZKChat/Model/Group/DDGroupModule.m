//
//  DDGroupModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDGroupModule.h"
#import "ZKDatabaseUtil+Users.h"

@implementation DDGroupModule
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allGroups = [NSMutableDictionary new];
        [[ZKDatabaseUtil instance] loadGroupsCompletion:^(NSArray *contacts, NSError *error) {
            [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ZKGroupEntity *group = (ZKGroupEntity *)obj;
                if(group.objID)
                {
                    [self addGroup:group];
                    GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
                    [request requestWithObject:@[@([ZKUtil changeIDToOriginal:group.objID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
                        if (!error)
                        {
                            if ([response count]) {
                                ZKGroupEntity* group = (ZKGroupEntity*)response[0];
                                if (group)
                                {
                                    [self addGroup:group];
                                    [[ZKDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                                        DDLog(@"insert group to database error.");
                                    }];
                                }
                            }
                            
                        }
                    }];
                    
                }
            }];
        }];
        [self registerAPI];
    }
    return self;
}

+ (instancetype)instance
{
    static DDGroupModule* group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        group = [[DDGroupModule alloc] init];
        
    });
    return group;
}
-(void)getGroupFromDB
{
    
}
-(void)addGroup:(ZKGroupEntity*)newGroup
{
    if (!newGroup)
    {
        return;
    }
    ZKGroupEntity* group = newGroup;
    [_allGroups setObject:group forKey:group.objID];
    newGroup = nil;
}
-(NSArray*)getAllGroups
{
    return [_allGroups allValues];
}
-(ZKGroupEntity*)getGroupByGId:(NSString*)gId
{
    
    ZKGroupEntity *entity= [_allGroups safeObjectForKey:gId];
    
    return entity;
}

- (void)getGroupInfogroupID:(NSString*)groupID completion:(GetGroupInfoCompletion)completion
{
    ZKGroupEntity *group = [self getGroupByGId:groupID];
    if (group) {
        completion(group);
    }else{
        GetGroupInfoAPI* request = [[GetGroupInfoAPI alloc] init];
        [request requestWithObject:@[@([MTTUtil changeIDToOriginal:groupID]),@(group.objectVersion)] Completion:^(id response, NSError *error) {
            if (!error)
            {
                if ([response count]) {
                    ZKGroupEntity* group = (ZKGroupEntity*)response[0];
                    if (group)
                    {
                        [self addGroup:group];
                        [[ZKDatabaseUtil instance] updateRecentGroup:group completion:^(NSError *error) {
                            DDLog(@"insert group to database error.");
                        }];
                    }
                    completion(group);
                }
                
            }
        }];
    }
    
}

-(BOOL)isContainGroup:(NSString*)gId
{
    return ([_allGroups valueForKey:gId] != nil);
}

- (void)registerAPI
{
    
    DDReceiveGroupAddMemberAPI* addmemberAPI = [[DDReceiveGroupAddMemberAPI alloc] init];
    [addmemberAPI registerAPIInAPIScheduleReceiveData:^(id object, NSError *error) {
        if (!error)
        {
            
            ZKGroupEntity* groupEntity = (ZKGroupEntity*)object;
            if (!groupEntity)
            {
                return;
            }
            if ([self getGroupByGId:groupEntity.objID])
            {
                //自己本身就在组中
                
            }
            else
            {
                //自己被添加进组中
                
                groupEntity.lastUpdateTime = [[NSDate date] timeIntervalSince1970];
                [[DDGroupModule instance] addGroup:groupEntity];

                [[NSNotificationCenter defaultCenter] postNotificationName:DDNotificationRecentContactsUpdate object:nil];
            }
        }
        else
        {
            DDLog(@"error:%@",[error domain]);
        }
    }];
}
@end
