//
//  ZKAFNetworkingClient.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/10.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKAFNetworkingClient.h"
#import "NSDictionary+Safe.h"
#import "ZKConstant.h"

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil;

@implementation ZKAFNetworkingClient
+(void) handleRequest:(id)result
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure
{
    
    if (![result isKindOfClass:[NSDictionary class]]) {
        NSError * error = [NSError errorWithDomain:@"data formate is invalid" code:-1000 userInfo:nil];
        BLOCK_SAFE_RUN(failure,error);
        return;
    }
    NSInteger code =[[[result safeObjectForKey:@"status"] objectForKey:@"code"] integerValue];
    NSString *msg =[[result safeObjectForKey:@"status"] objectForKey:@"msg"];
    if (1001 == code)
    {
        id object = [result valueForKey:@"result"];
        object = isNull(object) ? result : object;
        BLOCK_SAFE_RUN(success,object);
    }
    else
    {
        
        if (msg)
        {
            NSError* error = [NSError errorWithDomain:msg code:code userInfo:nil];
            BLOCK_SAFE_RUN(failure,error);
        }
        else
        {
            failure(nil);
        }
    }
    
    
}

+(void) jsonFormPOSTRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@<------",string);
        [ZKAFNetworkingClient handleRequest:responseDictionary success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([error.domain isEqualToString:NSURLErrorDomain])
            error = [NSError errorWithDomain:@"没有网络连接。" code:-100 userInfo:nil];
        BLOCK_SAFE_RUN(failure,error);
    }];
}
+(void) jsonFormGETRequest:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@<------",string);
        [ZKAFNetworkingClient handleRequest:responseDictionary success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if([error.domain isEqualToString:NSURLErrorDomain])
            error = [NSError errorWithDomain:@"没有网络连接。" code:-100 userInfo:nil];
        BLOCK_SAFE_RUN(failure,error);
    }];

}
@end
