//
//  DDTcpServer.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ClientSuccess)();
typedef void(^ClientFailure)(NSError* error);

@interface DDTcpServer : NSObject

- (void)loginTcpServerIP:(NSString*)ip port:(NSInteger)point Success:(void(^)())success failure:(void(^)())failure;

@end
