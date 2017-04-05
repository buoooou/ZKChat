//
//  NSDictionary+JSON.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/5.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)
- (NSString*)jsonString
{
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSDictionary*)initWithJsonString:(NSString*)json
{
    NSData* infoData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    return info;
}
@end
