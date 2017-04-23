//
//  DDMessageModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDMessageModule.h"
#import "ZKConstant.h"
#import "MsgReadACKAPI.h"
#import "ZKNotification.h"
#import "ZKDatabaseUtil.h"

@interface DDMessageModule(){
    
    NSMutableDictionary* _unreadMessages;
}

@end
@implementation DDMessageModule
+ (instancetype)shareInstance
{
    static DDMessageModule* g_messageModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_messageModule = [[DDMessageModule alloc] init];
    });
    return g_messageModule;
}
- (id)init
{
    self = [super init];
    if (self)
    {
        //注册收到消息API
        self.unreadMsgCount =0;
        _unreadMessages = [[NSMutableDictionary alloc] init];
        
        [self p_registerReceiveMessageAPI];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSUInteger )getMessageID
{
    NSInteger messageID = [[NSUserDefaults standardUserDefaults] integerForKey:@"msg_id"];
    if(messageID == 0)
    {
        messageID=LOCAL_MSG_BEGIN_ID;
    }else{
        messageID ++;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:messageID forKey:@"msg_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return messageID;
}
-(void)sendMsgRead:(ZKMessageEntity *)message
{
    MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
    [readACK requestWithObject:@[message.sessionId,@(message.msgID),@(message.sessionType)] Completion:nil];
}


-(void)removeAllUnreadMessages{
    
    [_unreadMessages removeAllObjects];
}


- (NSUInteger)getUnreadMessgeCount
{
    __block NSUInteger count = 0;
    [_unreadMessages enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        count += [obj count];
    }];
    
    return count;
}
#pragma mark - privateAPI
- (void)p_registerReceiveMessageAPI
{
    DDReceiveMessageAPI* receiveMessageAPI = [[DDReceiveMessageAPI alloc] init];
    [receiveMessageAPI registerAPIInAPIScheduleReceiveData:^(ZKMessageEntity* object, NSError *error) {
        object.state=DDmessageSendSuccess;
        DDReceiveMessageACKAPI *rmack = [[DDReceiveMessageACKAPI alloc] init];
        [rmack requestWithObject:@[object.senderId,@(object.msgID),object.sessionId,@(object.sessionType)] Completion:^(id response, NSError *error) {
            
        }];
        NSArray* messages = [self p_spliteMessage:object];
        //        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //            [self p_saveReceivedMessage:obj];
        //        }];
        if ([object isGroupMessage]) {
            ZKGroupEntity *group = [[DDGroupModule instance] getGroupByGId:object.sessionId];
            if (group.isShield == 1) {
                MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                [readACK requestWithObject:@[object.sessionId,@(object.msgID),@(object.sessionType)] Completion:nil];
            }
        }
        [[ZKDatabaseUtil instance] insertMessages:@[object] success:^{
            
        } failure:^(NSString *errorDescripe) {
            
        }];
        [ZKNotification postNotification:DDNotificationReceiveMessage userInfo:nil object:object];
    }];
    
}

@end
