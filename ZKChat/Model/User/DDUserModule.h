//
//  DDUserModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/15.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUserEntity.h"


typedef void(^DDLoadRecentUsersCompletion)();

@interface DDUserModule : NSObject

@property (nonatomic,strong)NSString* currentUserID;
@property (nonatomic,strong)NSMutableDictionary* recentUsers;
+ (instancetype)shareInstance;
- (void)addMaintanceUser:(ZKUserEntity*)user;
- (void)getUserForUserID:(NSString*)userID Block:(void(^)(ZKUserEntity *user))block;
- (void)addRecentUser:(ZKUserEntity*)user;
- (void)loadAllRecentUsers:(DDLoadRecentUsersCompletion)completion;
-(void)clearRecentUser;
-(NSArray *)getAllMaintanceUser;
-(NSArray *)getAllUsersNick;
-(ZKUserEntity *)getUserByNick:(NSString*)nickName;

@end
