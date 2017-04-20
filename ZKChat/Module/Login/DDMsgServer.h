//
//  DDMsgServer.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMsgServer : NSObject
/**
 *  连接消息服务器
 *
 *  @param userID  用户ID
 *  @param token   token
 *  @param success 连接成功执行的block
 *  @param failure 连接失败执行的block
 */
-(void)checkUserID:(NSString*)userID Pwd:(NSString *)password token:(NSString*)token success:(void(^)(id object))success failure:(void(^)(id object))failure;
@end
