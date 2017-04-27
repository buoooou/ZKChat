//
//  ZKAvatarManager.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAvatarManager : NSObject
+ (instancetype)shareInstance;

- (void)addKey:(NSString*)key Avatar:(NSArray *)avatar forLayout:(NSArray *)layout;
@end
