//
//  DDMessageModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKMessageEntity.h"
#import "ZKSessionEntity.h"

@interface DDMessageModule : NSObject
@property(assign)NSInteger unreadMsgCount;
+ (instancetype)shareInstance;

+ (NSUInteger )getMessageID;

- (void)removeFromUnreadMessageButNotSendRead:(NSString*)sessionID;
- (void)removeAllUnreadMessages;
- (NSUInteger)getUnreadMessgeCount;

-(void)sendMsgRead:(ZKMessageEntity *)message;
-(void)getMessageFromServer:(NSInteger)fromMsgID currentSession:(ZKSessionEntity *)session count:(NSInteger)count Block:(void(^)(NSMutableArray *array, NSError *error))block;

@end
