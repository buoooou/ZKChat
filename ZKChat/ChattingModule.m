//
//  ChattingModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ChattingModule.h"
static NSUInteger const showPromptGap = 300;
@interface ChattingModule(privateAPI)
- (NSUInteger)p_getMessageCount;
- (void)p_addHistoryMessages:(NSArray*)messages Completion:(DDChatLoadMoreHistoryCompletion)completion;

@end

@implementation ChattingModule
{
    //只是用来获取cell的高度的
//    DDChatTextCell* _textCell;
    
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
//    [[DDMessageModule shareInstance] getMessageFromServer:0 currentSession:self.ZKMessageEntity count:20 Block:^(NSMutableArray *response, NSError *error) {
//        //[self p_addHistoryMessages:response Completion:completion];
//        NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
//        if ( msgID !=0) {
//            if (response) {
//                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msgTime" ascending:YES];
//                [response sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//                [[MTTDatabaseUtil instance] insertMessages:response success:^{
//                    MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
//                    if(msgID){
//                        [readACK requestWithObject:@[self.MTTSessionEntity.sessionID,@(msgID),@(self.MTTSessionEntity.sessionType)] Completion:nil];
//                    }
//                } failure:^(NSString *errorDescripe) {
//                    
//                }];
//                [response enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [self addShowMessage:obj];
//                }];
//                completion([response count],error);
//                
//            }
//            
//            
//        }else{
//            completion(0,error);
//        }
//        
//    }];
}
-(void)loadHisToryMessageFromServer:(NSUInteger)FromMsgID loadCount:(NSUInteger)count Completion:(DDChatLoadMoreHistoryCompletion)completion
{
//    if (self.ZKSessionEntity) {
//        if (FromMsgID !=1) {
////            [[DDMessageModule shareInstance] getMessageFromServer:FromMsgID currentSession:self.ZKSessionEntity count:count Block:^(NSArray *response, NSError *error) {
//                //[self p_addHistoryMessages:response Completion:completion];
//                NSUInteger msgID = [[response valueForKeyPath:@"@max.msgID"] integerValue];
//                if ( msgID !=0) {
//                    if (response) {
//                        [[MTTDatabaseUtil instance] insertMessages:response success:^{
//                            MsgReadACKAPI* readACK = [[MsgReadACKAPI alloc] init];
//                            [readACK requestWithObject:@[self.MTTSessionEntity.sessionID,@(msgID),@(self.MTTSessionEntity.sessionType)] Completion:nil];
//                            
//                        } failure:^(NSString *errorDescripe) {
//                            
//                        }];
//                        NSUInteger count = [self p_getMessageCount];
//                        [[MTTDatabaseUtil instance] loadMessageForSessionID:self.ZKSessionEntity.sessionID pageCount:DD_PAGE_ITEM_COUNT index:count completion:^(NSArray *messages, NSError *error) {
//                            [self p_addHistoryMessages:messages Completion:completion];
//                            completion([response count],error);
//                        }];
//                        
//                    }
//                    
//                    
////                }else{
////                    completion(0,error);
////                }
//                
////            }];
////        }else{
////            completion(0,nil);
////        }
//        
//    }
}
-(void)loadHostoryMessageFromServer:(NSUInteger)FromMsgID Completion:(DDChatLoadMoreHistoryCompletion)completion{
    [self loadHisToryMessageFromServer:FromMsgID loadCount:19 Completion:completion];
}

@end
