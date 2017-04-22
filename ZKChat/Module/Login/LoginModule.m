//
//  LoginModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/19.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "LoginModule.h"

@implementation LoginModule

+(instancetype) instance{
    static LoginModule *loginModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModule=[[LoginModule alloc]init];
    });
    return loginModule;
}


@end
