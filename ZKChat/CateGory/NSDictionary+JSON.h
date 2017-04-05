//
//  NSDictionary+JSON.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/5.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (NSString*)jsonString;
+ (NSDictionary*)initWithJsonString:(NSString*)json;

@end
