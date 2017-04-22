//
//  DDHttpServer.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHttpServer : NSObject
///**
// *  登录Http服务器
// *
// *  @param userName 用户名
// *  @param password 密码
// *  @param success  登录成功回调的block
// *  @param failure  登录失败回调的block
// */
//- (void)loginWithUserName:(NSString*)userName
//                 password:(NSString*)password
//                  success:(void(^)(id respone))success
//                  failure:(void(^)(id error))failure;
-(void)getMsgIp:(void(^)(NSDictionary *dic))block failure:(void(^)(NSString* error))failure;
@end
