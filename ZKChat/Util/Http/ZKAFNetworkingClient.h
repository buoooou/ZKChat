//
//  ZKAFNetworkingClient.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/10.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ZKAFNetworkingClient : NSObject
+(void) jsonFormPOSTRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+(void) jsonFormGETRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
