//
//  ZKGroupEntity.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseEntity.h"
static NSString* const GROUP_PRE = @"group_";          //group id 前缀

enum
{
    GROUP_TYPE_FIXED = 1,       //固定群
    GROUP_TYPE_TEMPORARY,       //临时群
};
@class GroupInfo;
@interface ZKGroupEntity : ZKBaseEntity

@property(copy) NSString *groupCreatorId;        //群创建者ID
@property(nonatomic,assign) int groupType;                //群类型
@property(nonatomic,strong) NSString* name;                  //群名称
@property(nonatomic,strong) NSString* avatar;                //群头像
@property(nonatomic,strong) NSMutableArray* groupUserIds;    //群用户列表ids
@property(nonatomic,readonly)NSMutableArray* fixGroupUserIds;//固定的群用户列表IDS，用户生成群头像
@property(strong)NSString *lastMsg;
@property(assign)BOOL isShield;
-(void)copyContent:(ZKGroupEntity*)entity;
+(UInt32)localGroupIDTopb:(NSString *)groupID;
+(NSString *)pbGroupIdToLocalID:(UInt32)groupID;
- (void)addFixOrderGroupUserIDS:(NSString*)ID;
+(ZKGroupEntity *)dicToZKGroupEntity:(NSDictionary *)dic;
+(NSString *)getSessionId:(NSString *)groupId;
+(ZKGroupEntity *)initZKGroupEntityFromPBData:(GroupInfo *)groupInfo;

@end
