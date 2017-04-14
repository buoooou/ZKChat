//
//  RuntimeStatus.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUserEntity.h"
#define TheRuntime [RuntimeStatus instance]

@interface RuntimeStatus : NSObject

@property(nonatomic,strong)ZKUserEntity *user;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *pushToken;
@property(nonatomic,strong)NSDictionary *updateInfo;

+ (instancetype)instance;

-(void)updateData;

@end
