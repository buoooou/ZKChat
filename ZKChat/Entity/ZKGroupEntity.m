//
//  ZKGroupEntity.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKGroupEntity.h"
#import "IMBaseDefine.pb.h"
#import "NSDictionary+Safe.h"
#import "ZKUtil.h"

@implementation ZKGroupEntity
- (void)setGroupUserIds:(NSMutableArray *)groupUserIds
{
    if (_groupUserIds)
    {
        _groupUserIds = nil;
        _fixGroupUserIds = nil;
    }
    //    _groupUserIds = groupUserIds;
    NSArray *tmp = [[NSArray alloc]init];
    tmp = [groupUserIds sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *uid1 = [obj1 stringByReplacingOccurrencesOfString:@"user_" withString:@""];
        NSString *uid2 = [obj2 stringByReplacingOccurrencesOfString:@"user_" withString:@""];
        if([uid1 integerValue]>[uid2 integerValue]){
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    _groupUserIds = [[NSMutableArray alloc]initWithArray:tmp];
    [_groupUserIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addFixOrderGroupUserIDS:obj];
    }];
}

-(void)copyContent:(ZKGroupEntity*)entity
{
    self.groupType = entity.groupType;
    self.lastUpdateTime = entity.lastUpdateTime;
    self.name = entity.name;
    self.avatar = entity.avatar;
    self.groupUserIds = entity.groupUserIds;
}

+(NSString *)getSessionId:(NSString *)groupId
{
    return groupId;
}
+(NSString *)pbGroupIdToLocalID:(UInt32)groupID
{
    return [NSString stringWithFormat:@"%@%ld",GROUP_PRE,groupID];
}
+(UInt32)localGroupIDTopb:(NSString *)groupID
{
    if (![groupID hasPrefix:GROUP_PRE]) {
        return 0;
    }
    return [[groupID substringFromIndex:[GROUP_PRE length]] intValue];
}
+(ZKGroupEntity *)initZKGroupEntityFromPBData:(GroupInfo *)groupInfo
{
    ZKGroupEntity *group = [ZKGroupEntity new];
    group.objID=[self pbGroupIdToLocalID:groupInfo.groupId];
    group.objectVersion=groupInfo.version;
    group.name=groupInfo.groupName;
    group.avatar = groupInfo.groupAvatar;
    group.groupCreatorId = [ZKUtil changeOriginalToLocalID:groupInfo.groupCreatorId SessionType:SessionTypeSessionTypeSingle];
    group.groupType = groupInfo.groupType;
    group.isShield=groupInfo.shieldStatus;
    NSMutableArray *ids  = [NSMutableArray new];
    for (int i = 0; i<[[groupInfo groupMemberList] count]; i++) {
        [ids addObject:[ZKUtil changeOriginalToLocalID:[[groupInfo groupMemberList][i] integerValue] SessionType:SessionTypeSessionTypeSingle]];
    }
    group.groupUserIds = ids;
    group.lastMsg=@"";
    return group;
}
- (void)addFixOrderGroupUserIDS:(NSString*)ID
{
    if (!_fixGroupUserIds)
    {
        _fixGroupUserIds = [[NSMutableArray alloc] init];
    }
    [_fixGroupUserIds addObject:ID];
}

+(ZKGroupEntity *)dicToZKGroupEntity:(NSDictionary *)dic
{
    ZKGroupEntity *group = [ZKGroupEntity new];
    group.groupCreatorId=[dic safeObjectForKey:@"creatID"];
    group.objID = [dic safeObjectForKey:@"groupId"];
    group.avatar = [dic safeObjectForKey:@"avatar"];
    group.groupType = [[dic safeObjectForKey:@"groupType"] intValue];
    group.name = [dic safeObjectForKey:@"name"];
    group.avatar = [dic safeObjectForKey:@"avatar"];
    group.isShield = [[dic safeObjectForKey:@"isshield"] boolValue];
    NSString *string =[dic safeObjectForKey:@"Users"];
    NSMutableArray *array =[NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"-"]] ;
    if ([array count] >0) {
        group.groupUserIds=[array copy];
    }
    group.lastMsg =[dic safeObjectForKey:@"lastMessage"];
    group.objectVersion = [[dic safeObjectForKey:@"version"] integerValue];
    group.lastUpdateTime=[[dic safeObjectForKey:@"lastUpdateTime"] longValue];
    return group;
}
-(BOOL)theVersionIsChanged
{
    return YES;
}
-(void)updateGroupInfo
{
    
}


@end
