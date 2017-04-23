//
//  DDAPIScheduleProtocol.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/23.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef id(^Analysis)(NSData* data);
typedef NSMutableData*(^Package)(id object,uint16_t seqNO);

@protocol DDAPIScheduleProtocol <NSObject>
@required

/**
 *  请求超时时间
 *
 *  @return 超时时间
 */
- (int)requestTimeOutTimeInterval;

/**
 *  请求的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)requestServiceID;

/**
 *  请求返回的serviceID
 *
 *  @return 对应的serviceID
 */
- (int)responseServiceID;

/**
 *  请求的commendID
 *
 *  @return 对应的commendID
 */
- (int)requestCommendID;

/**
 *  请求返回的commendID
 *
 *  @return 对应的commendID
 */
- (int)responseCommendID;

/**
 *  解析数据的block
 *
 *  @return 解析数据的block
 */
- (Analysis)analysisReturnData;

/**
 *  打包数据的block
 *
 *  @return 打包数据的block
 */
- (Package)packageRequestObject;
@end
