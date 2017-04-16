//
//  DDGroupModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKGroupEntity.h"

typedef void(^GetGroupInfoCompletion)(ZKGroupEntity* group);
@interface DDGroupModule : NSObject
+ (instancetype)instance;
@property(assign)NSInteger recentGroupCount;
@property(strong) NSMutableDictionary* allGroups;         //所有群列表,key:group id value:MTTGroupEntity
@property(strong) NSMutableDictionary* allFixedGroup;     //所有固定群列表
-(ZKGroupEntity*)getGroupByGId:(NSString*)gId;
-(void)addGroup:(ZKGroupEntity*)newGroup;
- (void)getGroupInfogroupID:(NSString*)groupID completion:(GetGroupInfoCompletion)completion;
-(NSArray*)getAllGroups;
@end
