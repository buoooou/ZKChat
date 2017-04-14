//
//  ZKDatabaseUtil+Message.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKDatabaseUtil.h"
@class ZKMessageEntity;

typedef void(^LoadMessageInSessionCompletion)(NSArray* messages,NSError* error);
typedef void(^MessageCountCompletion)(NSInteger count);
typedef void(^DeleteSessionCompletion)(BOOL success);
typedef void(^DDDBGetLastestMessageCompletion)(ZKMessageEntity* message,NSError* error);
typedef void(^DDUpdateMessageCompletion)(BOOL result);
typedef void(^DDGetLastestCommodityMessageCompletion)(ZKMessageEntity* message);

@interface ZKDatabaseUtil (Message)



@end
