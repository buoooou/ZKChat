//
//  DDUnrequestSuperAPI.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDAPIUnrequestScheduleProtocol.h"
#import "DDTcpProtocolHeader.h"

typedef void(^ReceiveData)(id object,NSError* error);

@interface DDUnrequestSuperAPI : NSObject

@property (nonatomic,copy)ReceiveData receivedData;
- (BOOL)registerAPIInAPIScheduleReceiveData:(ReceiveData)received;

@end
