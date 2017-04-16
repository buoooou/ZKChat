//
//  ZKDatabaseUtil+Users.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKDatabaseUtil.h"
#import "ZKMessageEntity.h"
#import "ZKUserEntity.h"
#import "ZKGroupEntity.h"
#import "ZKSessionEntity.h"

typedef void(^LoadRecentContactsComplection)(NSArray* contacts,NSError* error);
typedef void(^LoadAllContactsComplection)(NSArray* contacts,NSError* error);
typedef void(^LoadAllSessionsComplection)(NSArray* session,NSError* error);
typedef void(^UpdateRecentContactsComplection)(NSError* error);
typedef void(^InsertsRecentContactsCOmplection)(NSError* error);
typedef void(^DeleteSessionCompletion)(BOOL success);

@interface ZKDatabaseUtil (Users)
/**
 *  加载本地数据库的最近联系人列表
 *
 *  @param completion 完成加载
 */
- (void)loadContactsCompletion:(LoadRecentContactsComplection)completion;

/**
 *  更新本地数据库的最近联系人信息
 *
 *  @param completion 完成更新本地数据库
 */
- (void)updateContacts:(NSArray*)users inDBCompletion:(UpdateRecentContactsComplection)completion;

/**
 *  更新本地数据库某个用户的信息
 *
 *  @param user       某个用户
 *  @param completion 完成更新本地数据库
 */


/**
 *  插入本地数据库的最近联系人信息
 *
 *  @param users      最近联系人数组
 *  @param completion 完成插入
 */
- (void)insertUsers:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion;

- (void)insertAllUser:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion;

- (void)getAllUsers:(LoadAllContactsComplection )completion;

- (void)getUserFromID:(NSString*)userID completion:(void(^)(ZKUserEntity *user))completion;

- (void)updateRecentGroup:(ZKGroupEntity *)group completion:(InsertsRecentContactsCOmplection)completion;
- (void)updateRecentSessions:(NSArray *)sessions completion:(InsertsRecentContactsCOmplection)completion;
- (void)updateRecentSession:(ZKSessionEntity *)session completion:(InsertsRecentContactsCOmplection)completion;
- (void)loadGroupsCompletion:(LoadRecentContactsComplection)completion;
- (void)loadSessionsCompletion:(LoadAllSessionsComplection)completion;
-(void)removeSession:(NSString *)sessionID;
- (void)deleteMesages:(ZKMessageEntity * )message completion:(DeleteSessionCompletion)completion;
- (void)loadGroupByIDCompletion:(NSString *)groupID Block:(LoadRecentContactsComplection)completion;
@end
