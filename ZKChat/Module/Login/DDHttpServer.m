//
//  DDHttpServer.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDHttpServer.h"
#import "ZKAFNetworkingClient.h"
#import "ZKConfig.h"


@implementation DDHttpServer


- (void)loginWithUserName:(NSString*)userName
                 password:(NSString*)password
                  success:(void(^)(id respone))success
                  failure:(void(^)(id error))failure
{
    NSMutableDictionary* dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:userName forKey:@"user_email"];
    [dictParams setObject:password forKey:@"user_pass"];
    [dictParams setObject:@"ooxx" forKey:@"macim"];
    [dictParams setObject:@"1.0" forKey:@"imclient"];
    [dictParams setObject:@"1" forKey:@"remember"];
    [ZKAFNetworkingClient jsonFormPOSTRequest:@"user/zlogin/" param:dictParams success:^(id result) {
        success(result);
    } failure:^(NSError * error) {
        failure(error);
    }];
    
}
-(void)getMsgIp:(void(^)(NSDictionary *dic))block failure:(void(^)(NSString* error))failure
{
    
    [ZKAFNetworkingClient jsonFormGETRequest:SERVER_ADDR param:nil success:^(id responseObject) {
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        block(responseDictionary);
        
    } failure:^(NSError *error) {
        NSString *errordes = error.domain;
        failure(errordes);
    } ];
    
    
    
}

@end
