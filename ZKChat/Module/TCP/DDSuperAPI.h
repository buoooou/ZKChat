//
//  DDSuperAPI.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCompletion)(id response,NSError* error);
/**
 *  这是一个超级类，不能被直接使用
 */
#define TimeOutTimeInterval 10
@interface DDSuperAPI : NSObject

@property (nonatomic,copy)RequestCompletion completion;
@property (nonatomic,readonly)uint16_t seqNo;

- (void)requestWithObject:(id)object Completion:(RequestCompletion)completion;

@end
