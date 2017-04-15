//
//  ZKSessionEntity.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBaseDefine.pb.h"
#import "ZKUserEntity.h"
#import "ZKGroupEntity.h"


@interface ZKSessionEntity : NSObject
@property (nonatomic,retain)NSString* sessionID;
@property (nonatomic,assign)SessionType sessionType;
@property (nonatomic,readonly)NSString* name;
@property(assign)NSInteger unReadMsgCount;
@property (assign)NSUInteger timeInterval;
@property(nonatomic,strong,readonly)NSString* orginId;
@property(assign)BOOL isShield;
@property(assign)BOOL isFixedTop;
@property(strong)NSString *lastMsg;
@property(assign)NSInteger lastMsgID;
@property(strong)NSString *avatar;
-(NSArray*)sessionUsers;
/**
 *  创建一个session，只需赋值sessionID和Type即可
 *
 *  @param sessionID 会话ID，群组传入groupid，p2p传入对方的userid
 *  @param type      会话的类型
 *
 *
 */
- (id)initWithSessionID:(NSString*)sessionID type:(SessionType)type;
- (id)initWithSessionID:(NSString*)sessionID SessionName:(NSString *)name type:(SessionType)type;
- (id)initWithSessionIDByUser:(ZKUserEntity*)user;
- (id)initWithSessionIDByGroup:(ZKGroupEntity*)group;
- (void)updateUpdateTime:(NSUInteger)date;
-(NSString *)getSessionGroupID;
-(void)setSessionName:(NSString *)theName;
-(BOOL)isGroup;
-(id)dicToGroup:(NSDictionary *)dic;
-(void)setSessionUser:(NSArray *)array;
@end
