//
//  SessionModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKSessionEntity.h"

typedef enum
{
    ADD = 0,
    REFRESH = 1,
    DELETE =2
}SessionAction;
@protocol SessionModuelDelegate<NSObject>
@optional
- (void)sessionUpdate:(ZKSessionEntity *)session Action:(SessionAction)action;
@end
@interface SessionModule : NSObject
@property(strong)id<SessionModuelDelegate>delegate;

+ (instancetype)instance;

-(NSArray *)getAllSessions;

-(void)addToSessionModel:(ZKSessionEntity *)session;

-(void)addSessionsToSessionModel:(NSArray *)sessionArray;

-(ZKSessionEntity *)getSessionById:(NSString *)sessionID;

-(void)getRecentSession:(void(^)(NSUInteger count))block;

-(void)removeSessionByServer:(ZKSessionEntity *)session;

-(void)clearSession;

-(void)loadLocalSession:(void(^)(bool isok))block;

-(void)getHadUnreadMessageSession:(void(^)(NSUInteger count))block;

-(NSUInteger)getAllUnreadMessageCount;


@end
