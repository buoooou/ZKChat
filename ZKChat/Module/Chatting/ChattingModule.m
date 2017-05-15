//
//  ChattingModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ChattingModule.h"
#import "ZKMessageEntity.h"
#import "NSDate+DDAddition.h"
#import "ZKConstant.h"
#import "DDChatTextCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "ZKUtil.h"
#import "DDMessageModule.h"
#import "ZKDatabaseUtil.h"
#import "MsgReadACKAPI.h"
#import "DDUserModule.h"

static NSUInteger const showPromptGap = 300;
@interface ChattingModule(privateAPI)
- (NSUInteger)p_getMessageCount;
- (void)p_addHistoryMessages:(NSArray*)messages Completion:(DDChatLoadMoreHistoryCompletion)completion;

@end

@implementation ChattingModule
{
    //只是用来获取cell的高度的
    DDChatTextCell* _textCell;
    
    NSUInteger _earliestDate;
    NSUInteger _lastestDate;
    
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.showingMessages = [[NSMutableArray alloc] init];
        self.ids = [NSMutableArray new];
    }
    return self;
}
- (void)setZKSessionEntity:(ZKSessionEntity *)ZKSessionEntity
{
    _ZKSessionEntity = ZKSessionEntity;
    
    self.showingMessages = nil;
    self.showingMessages = [[NSMutableArray alloc] init];
}

-(void)getNewMsg:(DDChatLoadMoreHistoryCompletion)completion
{
    [[DDMessageModule shareInstance] getMessageFromServer:0 currentSession:self.ZKSessionEntity count:20 Block:^(NSMutableArray *response, NSError *error) {
        //[self p_addHistoryMessages:response Completion:completion];
        NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
        if ( msgID !=0) {
            if (response) {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
                [response sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                [[ZKDatabaseUtil instance] insertMessages:response success:^{
                    MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                    if(msgID){
                        [readACK requestWithObject:@[self.ZKSessionEntity.sessionID,@(msgID),@(self.ZKSessionEntity.sessionType)] Completion:nil];
                    }
                } failure:^(NSString *errorDescripe) {
                    
                }];
                [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [self addShowMessage:obj];
                }];
                completion([response count],error);
                
            }
            
            
        }else{
            completion(0,error);
        }
        
    }];
}
-(void)loadHisToryMessageFromServer:(NSUInteger)FromMsgID loadCount:(NSUInteger)count Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    if (self.ZKSessionEntity) {
        if (FromMsgID !=1) {
            [[DDMessageModule shareInstance] getMessageFromServer:FromMsgID currentSession:self.ZKSessionEntity count:count Block:^(NSArray *response, NSError *error) {
                [self p_addHistoryMessages:response Completion:completion];
                NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
                if ( msgID !=0) {
                    if (response) {
                        [[ZKDatabaseUtil instance] insertMessages:response success:^{
                            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
                            [readACK requestWithObject:@[self.ZKSessionEntity.sessionID,@(msgID),@(self.ZKSessionEntity.sessionType)] Completion:nil];
                            
                        } failure:^(NSString *errorDescripe) {
                            
                        }];
                        NSUInteger count = [self p_getMessageCount];
                        [[ZKDatabaseUtil instance] loadMessageForSessionID:self.ZKSessionEntity.sessionID pageCount:PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error) {
                            [self p_addHistoryMessages:messages Completion:completion];
                            completion([response count],error);
                        }];
                        
                    }
                    
                    
                }else{
                    completion(0,error);
                }
                
            }];
        }else{
            completion(0,nil);
        }
        
    }
}
-(void)loadHostoryMessageFromServer:(NSUInteger)FromMsgID Completion:(DDChatLoadMoreHistoryCompletion)completion{
    [self loadHisToryMessageFromServer:FromMsgID loadCount:19 Completion:completion];
}
- (void)loadMoreHistoryCompletion:(DDChatLoadMoreHistoryCompletion)completion
{
    
    NSUInteger count = [self p_getMessageCount];
    
    [[ZKDatabaseUtil instance] loadMessageForSessionID:self.ZKSessionEntity.sessionID pageCount:PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error) {
        //after loading finish ,then add to messages
//        if ([DDClientState shareInstance].networkState == DDNetWorkDisconnect) {
//            [self p_addHistoryMessages:messages Completion:completion];
//        }else{
            if ([messages count] !=0) {
                
                BOOL isHaveMissMsg = [self p_isHaveMissMsg:messages];
                if (isHaveMissMsg || ([self getMiniMsgId] - [self getMaxMsgId:messages] !=0)) {
                    
                    [self loadHostoryMessageFromServer:[self getMiniMsgId] Completion:^(NSUInteger addcount, NSError *error) {
                        if (addcount) {
                            completion(addcount,error);
                        }else{
                            [self p_addHistoryMessages:messages Completion:completion];
                        }
                    }];
                }else{
                    //检查消息是否连续
                    [self p_addHistoryMessages:messages Completion:completion];
                }
                
            }else{
                //数据库中已获取不到消息
                //拿出当前最小的msgid去服务端取
                [self loadHostoryMessageFromServer:[self getMiniMsgId] Completion:^(NSUInteger addcount, NSError *error) {
                    completion(addcount,error);
                }];
            }
            
            
//        }
        
    }];
}
- (void)loadAllHistoryCompletion:(ZKMessageEntity*)message Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    [[ZKDatabaseUtil instance] loadMessageForSessionID:self.ZKSessionEntity.sessionID afterMessage:message completion:^(NSArray *messages, NSError *error) {
        [self p_addHistoryMessages:messages Completion:completion];
    }];
}
-(NSUInteger )getMiniMsgId
{
    if ([self.showingMessages count] == 0) {
        return self.ZKSessionEntity.lastMsgID;
    }
    __block NSInteger minMsgID =[self getMaxMsgId:self.showingMessages];
    
    [self.showingMessages enumerateObjectsUsingBlock:^(ZKMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ZKMessageEntity class]]) {
            if(obj.msgID <minMsgID)
            {
                minMsgID = obj.msgID;
            }
        }
    }];
    return minMsgID;
}

- (float)messageHeight:(ZKMessageEntity*)message
{
    
    if (message.msgContentType == DDMessageTypeText ) {
        if (!_textCell)
        {
            _textCell = [[DDChatTextCell alloc] init];
        }
        return [_textCell cellHeightForMessage:message];
        
    }else if (message.msgContentType == DDMessageTypeVoice )
    {
        return 60;
    }else if(message.msgContentType == DDMessageTypeImage)
    {
        float height = 150;
        NSString* urlString = message.msgContent;
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
        NSURL* url = [NSURL URLWithString:urlString];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if( [manager cachedImageExistsForURL:url]){
            NSString *key = [manager cacheKeyForURL:url];
            UIImage *curImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            height = [ZKUtil sizeTrans:curImg.size].height;
        }
        float last_height = height+20;;
        return last_height>60?last_height:60;
    }
    else if(message.msgContentType == DDMEssageEmotion){
        return 133+20;
    }
    else
    {
        return 135;
    }
    
}
- (void)addShowMessage:(ZKMessageEntity*)message
{
    if (![self.ids containsObject:@(message.msgID)]) {
        if (message.msgTime - _lastestDate > showPromptGap)
        {
            _lastestDate = message.msgTime;
            DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
            prompt.message = [date promptDateString];
            [self.showingMessages addObject:prompt];
            
        }
        NSArray *array = [[self class] p_spliteMessage:message];
        [array enumerateObjectsUsingBlock:^(ZKMessageEntity* obj, NSUInteger idx, BOOL *stop) {
            [[self mutableArrayValueForKeyPath:@"showingMessages"] addObject:obj];
        }];
    }
}

- (void)addShowMessages:(NSArray*)messages
{
    
    [[self mutableArrayValueForKeyPath:@"showingMessages"] addObjectsFromArray:messages];
}
-(void)getCurrentUser:(void(^)(ZKUserEntity *))block
{
    [[DDUserModule shareInstance] getUserForUserID:self.ZKSessionEntity.sessionID  Block:^(ZKUserEntity *user) {
        block(user);
    }];
    
}


- (void)updateSessionUpdateTime:(NSUInteger)time
{
    [self.ZKSessionEntity updateUpdateTime:time];
    _lastestDate = time;
}

#pragma mark PrivateAPI
- (NSUInteger)p_getMessageCount
{
    __block NSUInteger count = 0;
    [self.showingMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"ZKMessageEntity")])
        {
            count ++;
        }
    }];
    return count;
}

- (void)p_addHistoryMessages:(NSArray*)messages Completion:(DDChatLoadMoreHistoryCompletion)completion
{
    
    __block NSUInteger tempEarliestDate = [[messages valueForKeyPath:@"@min.msgTime"] integerValue];
    __block NSUInteger tempLasteestDate = 0;
    NSUInteger itemCount = [self.showingMessages count];
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:messages];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
        [tmp sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSMutableArray* tempMessages = [[NSMutableArray alloc] init];
    for (NSInteger index = [tmp count] - 1; index >= 0;index --)
    {
        
        ZKMessageEntity* message = tmp[index];
        
        
        if ([self.ids containsObject:@(message.msgID)]) {
            continue;
        }
                    if (index == [tmp count] - 1)
                    {
                        tempEarliestDate = message.msgTime;
        
                    }
        if (message.msgTime - tempLasteestDate > showPromptGap)
        {
            DDPromptEntity* prompt = [[DDPromptEntity alloc] init];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:message.msgTime];
            prompt.message = [date promptDateString];
            [tempMessages addObject:prompt];
        }
        tempLasteestDate = message.msgTime;
        NSArray *array = [[self class] p_spliteMessage:message];
        [array enumerateObjectsUsingBlock:^(ZKMessageEntity * obj, NSUInteger idx, BOOL *stop) {
            
            [self.ids addObject:@(message.msgID)];
            [tempMessages addObject:obj];
        }];
    }
    
    if ([self.showingMessages count] == 0)
    {
        [[self mutableArrayValueForKeyPath:@"showingMessages"] addObjectsFromArray:tempMessages];
        _earliestDate = tempEarliestDate;
        _lastestDate = tempLasteestDate;
    }
    else
    {
        [self.showingMessages insertObjects:tempMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [tempMessages count])]];
        _earliestDate = tempEarliestDate;
    }
    NSUInteger newItemCount = [self.showingMessages count];
    completion(newItemCount - itemCount,nil);
}

+ (NSArray*)p_spliteMessage:(ZKMessageEntity*)message
{
    message.msgContent = [message.msgContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* messageContentArray = [[NSMutableArray alloc] init];
    
    if ( [ message.msgContent rangeOfString:DD_MESSAGE_IMAGE_PREFIX].length > 0)
    {
        NSString* messageContent = [message msgContent];
        if ([messageContent rangeOfString:DD_MESSAGE_IMAGE_PREFIX].length > 0 && [messageContent rangeOfString:DD_IMAGE_LOCAL_KEY].length > 0 && [messageContent rangeOfString:DD_IMAGE_URL_KEY].length > 0) {
            ZKMessageEntity* messageEntity = [[ZKMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:messageContent toUserID:message.toUserID];
            messageEntity.msgContentType = DDMessageTypeImage;
            messageEntity.state = DDmessageSendSuccess;
        }else{
            
            NSArray* tempMessageContent = [messageContent componentsSeparatedByString:DD_MESSAGE_IMAGE_PREFIX];
            [tempMessageContent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString* content = (NSString*)obj;
                if ([content length] > 0)
                {
                    NSRange suffixRange = [content rangeOfString:DD_MESSAGE_IMAGE_SUFFIX];
                    if (suffixRange.length > 0)
                    {
                        //是图片,再拆分
                        NSString* imageContent = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,[content substringToIndex:suffixRange.location + suffixRange.length]];
                        ZKMessageEntity* messageEntity = [[ZKMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:imageContent toUserID:message.toUserID];
                        messageEntity.msgContentType = DDMessageTypeImage;
                        messageEntity.state = DDmessageSendSuccess;
                        [messageContentArray addObject:messageEntity];
                        
                        
                        NSString* secondComponent = [content substringFromIndex:suffixRange.location + suffixRange.length];
                        if (secondComponent.length > 0)
                        {
                            ZKMessageEntity* secondmessageEntity = [[ZKMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:secondComponent toUserID:message.toUserID];
                            secondmessageEntity.msgContentType = DDMessageTypeText;
                            secondmessageEntity.state = DDmessageSendSuccess;
                            [messageContentArray addObject:secondmessageEntity];
                        }
                    }
                    else
                    {
                        
                        ZKMessageEntity* messageEntity = [[ZKMessageEntity alloc] initWithMsgID:[DDMessageModule getMessageID] msgType:message.msgType msgTime:message.msgTime sessionID:message.sessionId senderID:message.senderId msgContent:content toUserID:message.toUserID];
                        messageEntity.state = DDmessageSendSuccess;
                        [messageContentArray addObject:messageEntity];
                    }
                }
            }];
        }
    }
    
    if ([messageContentArray count] == 0)
    {
        [messageContentArray addObject:message];
    }
    
    return messageContentArray;
    
}
-(NSInteger)getMaxMsgId:(NSArray *)array
{
    __block NSInteger maxMsgID =0;
    [array enumerateObjectsUsingBlock:^(ZKMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ZKMessageEntity class]]) {
            if (obj.msgID > maxMsgID && obj.msgID<LOCAL_MSG_BEGIN_ID) {
                maxMsgID =obj.msgID;
            }
        }
    }
     ];
    return maxMsgID;
}
- (BOOL)p_isHaveMissMsg:(NSArray*)messages
{
    
    __block NSInteger maxMsgID =[self getMaxMsgId:messages];
    __block NSInteger minMsgID =[self getMaxMsgId:messages];;
    [messages enumerateObjectsUsingBlock:^(ZKMessageEntity * obj, NSUInteger idx, BOOL *stop) {
        if (obj.msgID > maxMsgID && obj.msgID<LOCAL_MSG_BEGIN_ID) {
            //maxMsgID =obj.msgID;
        }else if(obj.msgID <minMsgID)
        {
            minMsgID = obj.msgID;
        }
    }];
    
    NSUInteger diff = maxMsgID - minMsgID;
    if (diff != 19) {
        return YES;
    }
    return NO;
}

-(void)checkMsgList:(DDChatLoadMoreHistoryCompletion)completion
{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.showingMessages];
    [tmp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DDPromptEntity class]]) {
            [tmp removeObject:obj];
        }else{
            ZKMessageEntity *msg = obj;
            if (msg.msgID>=LOCAL_MSG_BEGIN_ID) {
                [tmp removeObject:obj];
            }
        }
        
    }];
    
    [tmp enumerateObjectsUsingBlock:^(ZKMessageEntity *obj, NSUInteger idx, BOOL *stop) {
        if (idx +1 < [tmp count]) {
            ZKMessageEntity * msg = [tmp objectAtIndex:idx+1];
            if (abs(obj.msgID - msg.msgID) !=1) {
                [self loadHisToryMessageFromServer:MIN(obj.msgID, msg.msgID) loadCount:abs(obj.msgID - msg.msgID) Completion:^(NSUInteger addcount, NSError *error) {
                    completion(addcount,error);
                }];
            }
        }
        
    }];
}
@end
@implementation DDPromptEntity

@end
