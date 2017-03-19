//
//  ZKUtil.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKUtil : NSObject
+(NSString *)changeOriginalToLocalID:(UInt32)orignalID SessionType:(int)sessionType;
+(NSDate *)getLastPhotoTime;
+(void)setLastPhotoTime:(NSDate *)date;
+(void)setDBVersion:(NSInteger)version;
+(NSString *)getBubbleTypeLeft:(BOOL)left;
+(void)setBubbleTypeLeft:(NSString *)bubbleType left:(BOOL)left;
@end
