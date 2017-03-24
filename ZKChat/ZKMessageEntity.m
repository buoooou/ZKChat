//
//  ZKMessageEntity.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKMessageEntity.h"
#import "ChattingModule.h"
#import "RuntimeStatus.h"

@implementation ZKMessageEntity
- (ZKMessageEntity*)initWithMsgID:(NSUInteger )ID msgType:(MsgType)msgType msgTime:(double)msgTime sessionID:(NSString*)sessionID senderID:(NSString*)senderID msgContent:(NSString*)msgContent toUserID:(NSString*)toUserID
{
    self = [super init];
    if (self)
    {
        _msgID = ID;
        _msgType = msgType;
        _msgTime = msgTime;
        _sessionId = [sessionID copy];
        _senderId = [senderID copy];
        _msgContent =msgContent;
        _toUserID = [toUserID copy];
        _info = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    ZKMessageEntity *ddmentity =[[[self class] allocWithZone:zone] initWithMsgID:_msgID msgType:_msgType msgTime:_msgTime sessionID:_sessionId senderID:_senderId msgContent:_msgContent toUserID:_toUserID];
    return ddmentity;
}
- (NSString*):(NSString*)content
{
    
    NSMutableString *msgContent = [NSMutableString stringWithString:content?content:@""];
    NSMutableString *resultContent = [NSMutableString string];
    NSRange startRange;
    // NSDictionary* emotionDic = [EmotionsModule shareInstance].emotionUnicodeDic;
    while ((startRange = [msgContent rangeOfString:@"["]).location != NSNotFound) {
        if (startRange.location > 0)
        {
            NSString *str = [msgContent substringWithRange:NSMakeRange(0, startRange.location)];
            NSLog(@"[前文本内容:%@",str);
            [msgContent deleteCharactersInRange:NSMakeRange(0, startRange.location)];
            startRange.location=0;
            [resultContent appendString:str];
        }
        
        NSRange endRange = [msgContent rangeOfString:@"]"];
        if (endRange.location != NSNotFound) {
            NSRange range;
            range.location = 0;
            range.length = endRange.location + endRange.length;
            NSString *emotionText = [msgContent substringWithRange:range];
            [msgContent deleteCharactersInRange:
             NSMakeRange(0, endRange.location + endRange.length)];
            
            NSLog(@"类似表情字串:%@",emotionText);
            //            NSString *emotion = emotionDic[emotionText];
            //            if (emotion) {
            //                // 表情
            //                [resultContent appendString:emotion];
            //            } else
            //            {
            //                [resultContent appendString:emotionText];
            //            }
        } else {
            NSLog(@"没有[匹配的后缀");
            break;
        }
    }
    
    if ([msgContent length] > 0)
    {
        [resultContent appendString:msgContent];
    }
    return resultContent;
}
+(ZKMessageEntity *)makeMessage:(NSString *)content Module:(ChattingModule *)module MsgType:(DDMessageContentType )type
{
    double msgTime = [[NSDate date] timeIntervalSince1970];
    NSString* senderID = [RuntimeStatus instance].user.objID;
    MsgType msgType;
//    if (module.ZKMessageEntity.sessionType == SessionTypeSessionTypeSingle ) {
//        msgType =MsgTypeMsgTypeSingleText;
//    }else
//    {
        msgType =MsgTypeMsgTypeGroupText;
//    }
//    ZKMessageEntity* message = [[ZKMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:msgType msgTime:msgTime sessionID:module.ZKSessionEntity.sessionID senderID:senderID msgContent:content toUserID:module.ZKSessionEntity.sessionID];
     ZKMessageEntity* message = [[ZKMessageEntity alloc] initWithMsgID:@"ss" msgType:msgType msgTime:msgTime sessionID:@"zkzj" senderID:senderID msgContent:content toUserID:@"zkzs"];
    message.state = DDMessageSending;
    message.msgContentType=type;
    [module addShowMessage:message];
//    [module updateSessionUpdateTime:message.msgTime];
    return message;
}
-(BOOL)isGroupMessage
{
    if (self.msgType == MsgTypeMsgTypeGroupAudio || self.msgType == MsgTypeMsgTypeGroupText) {
        return YES;
    }
    return NO;
}

@end
