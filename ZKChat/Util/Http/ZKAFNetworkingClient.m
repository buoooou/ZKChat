//
//  ZKAFNetworkingClient.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/10.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKAFNetworkingClient.h"


@implementation ZKAFNetworkingClient
+(void) jsonFormPOSTRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}
+(void) jsonFormGETRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}
@end
