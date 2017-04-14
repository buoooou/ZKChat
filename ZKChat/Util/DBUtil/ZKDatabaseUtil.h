//
//  ZKDatabaseUtil.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/10.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface ZKDatabaseUtil : NSObject

+ (instancetype)instance;
@property(strong,readonly) dispatch_queue_t databaseMessageQueue;
@property(strong)NSString *recentsession;
- (void)openCurrentUserDB;

@end
