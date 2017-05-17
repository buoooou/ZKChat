//
//  DDMessageSendManager.h
//  ZKChat
//
//  Created by 张阔 on 2017/5/17.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKMessageEntity.h"
@class ZKSessionEntity;
typedef void(^DDSendMessageCompletion)(ZKMessageEntity* message,NSError* error);

typedef NS_ENUM(NSUInteger, MessageType)
{
    AllString,
    HasImage
};

@interface DDMessageSendManager : NSObject
@property (nonatomic,readonly)dispatch_queue_t sendMessageSendQueue;
@property (nonatomic,readonly)NSMutableArray* waitToSendMessage;
+ (instancetype)instance;


/**
 *  <#Description#>
 *
 *  @param message    <#message description#>
 *  @param isGroup    <#isGroup description#>
 *  @param session    <#session description#>
 *  @param completion <#completion description#>
 *  @param block      <#block description#>
 */
- (void)sendMessage:(ZKMessageEntity *)message isGroup:(BOOL)isGroup Session:(ZKSessionEntity*)session completion:(DDSendMessageCompletion)completion Error:(void(^)(NSError *error))block;


- (void)sendVoiceMessage:(NSData*)voice filePath:(NSString*)filePath forSessionID:(NSString*)sessionID isGroup:(BOOL)isGroup Message:(ZKMessageEntity *)msg Session:(ZKSessionEntity*)session completion:(DDSendMessageCompletion)completion;

@end
