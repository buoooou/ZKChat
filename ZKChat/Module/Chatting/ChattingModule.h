//
//  ChattingModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUserEntity.h"
#import "ZKSessionEntity.h"

@class ZKMessageEntity;
#define PAGE_ITEM_COUNT                  20
typedef void(^DDReuestServiceCompletion)(ZKUserEntity* user);
typedef void(^DDRequestGoodDetailCompletion)(NSDictionary* detail,NSError* error);
typedef void(^DDChatLoadMoreHistoryCompletion)(NSUInteger addcount, NSError* error);

@interface ChattingModule : NSObject

@property (strong)ZKSessionEntity* ZKSessionEntity;
@property(strong)NSMutableArray *ids ;
@property (strong)NSMutableArray* showingMessages;
@property (assign) NSInteger isGroup;
/**
 *  加载历史消息接口，这里会适时插入时间
 *
 *  @param completion 加载完成
 */
- (void)loadMoreHistoryCompletion:(DDChatLoadMoreHistoryCompletion)completion;
- (void)loadAllHistoryCompletion:(ZKMessageEntity*)message Completion:(DDChatLoadMoreHistoryCompletion)completion;

- (void)loadHostoryUntilCommodity:(ZKMessageEntity*)message completion:(DDChatLoadMoreHistoryCompletion)completion;

- (float)messageHeight:(ZKMessageEntity*)message;

- (void)addPrompt:(NSString*)prompt;
- (void)addShowMessage:(ZKMessageEntity*)message;
- (void)addShowMessages:(NSArray*)messages;
-(void)scanDBAndFixIDList:(void(^)(bool isok))block;
- (void)updateSessionUpdateTime:(NSUInteger)time;
- (void)clearChatData;
-(void)m_clearScanRecord;
- (void)showMessagesAddCommodity:(ZKMessageEntity*)message;
-(void)getCurrentUser:(void(^)(ZKUserEntity *))block;
-(void)loadHistoryMessageFromServer:(NSUInteger)FromMsgID loadCount:(NSUInteger)count Completion:(DDChatLoadMoreHistoryCompletion)completion;
-(void)loadHistoryMessageFromServer:(NSUInteger)FromMsgID Completion:(DDChatLoadMoreHistoryCompletion)completion;
+ (NSArray*)p_spliteMessage:(ZKMessageEntity*)message;
-(void)getNewMsg:(DDChatLoadMoreHistoryCompletion)completion;
@end

@interface DDPromptEntity : NSObject
@property(nonatomic,retain)NSString* message;

@end
