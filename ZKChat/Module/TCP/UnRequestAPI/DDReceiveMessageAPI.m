//
//  DDReceiveMessageAPI.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDReceiveMessageAPI.h"
#import "IMMessage.pb.h"
#import "ZKMessageEntity.h"

@implementation DDReceiveMessageAPI
- (int)responseServiceID
{
    return SID_MSG;
}

- (int)responseCommandID
{
    return IM_MSG_DATA;
}

- (UnrequestAPIAnalysis)unrequestAnalysis
{
    UnrequestAPIAnalysis analysis = (id)^(NSData *data)
    {
        IMMsgData *msgdata = [IMMsgData parseFromData:data];
        ZKMessageEntity *msg = [ZKMessageEntity makeMessageFromPBData:msgdata];
        msg.state=DDmessageSendSuccess;
        return msg;
    };
    return analysis;
}

@end
