//
//  DDTcpClientManager.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDSendBuffer.h"

@interface DDTcpClientManager : NSObject<NSStreamDelegate>
{
@private
    NSInputStream *_inStream;
    NSOutputStream *_outStream;
    NSLock *_receiveLock;
    NSMutableData *_receiveBuffer;
    NSLock *_sendLock;
    NSMutableArray *_sendBuffers;
    DDSendBuffer *_lastSendBuffer;
    BOOL _noDataSent;
    int32_t cDataLen;
    
}
+ (instancetype)instance;

-(void)connect:(NSString *)ipAdr port:(NSInteger)port status:(NSInteger)status;
-(void)disconnect;
-(void)writeToSocket:(NSMutableData *)data;
@end
