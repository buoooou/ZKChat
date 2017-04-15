//
//  ZKSessionEntity.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKSessionEntity.h"

@implementation ZKSessionEntity
@synthesize  name;
@synthesize timeInterval;
- (void)setSessionID:(NSString *)sessionID
{
    _sessionID = [sessionID copy];
    name = nil;
    timeInterval = 0;
}

- (void)setSessionType:(SessionType)sessionType
{
    _sessionType = sessionType;
    name = nil;
    timeInterval = 0;
}

- (NSString*)name
{
    if (!name)
    {
        switch (self.sessionType)
        {
            case SessionTypeSessionTypeSingle:
            {
                [[DDUserModule shareInstance] getUserForUserID:_sessionID Block:^(ZKUserEntity *user) {
                    if ([user.nick length] > 0)
                    {
                        name = user.nick;
                    }
                    else
                    {
                        name = user.name;
                    }
                    
                }];
            }
                break;
            case SessionTypeSessionTypeGroup:
            {
                ZKGroupEntity* group = [[DDGroupModule instance] getGroupByGId:_sessionID];
                if (!group) {
                    [[DDGroupModule instance] getGroupInfogroupID:_sessionID completion:^(ZKGroupEntity *group) {
                        name=group.name;
                    }];
                }else{
                    name=group.name;
                }
                
            }
                break;
                
        }
    }
    return name;
}
-(void)setSessionName:(NSString *)theName
{
    name = theName;
}

@end
