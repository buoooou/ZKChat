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
+(NSString *)getBubbleTypeLeft:(BOOL)left;
+(void)setBubbleTypeLeft:(NSString *)bubbleType left:(BOOL)left;
+(struct CGSize)sizeTrans:(struct CGSize)size;

#pragma db
+(void)setDBVersion:(NSInteger)version;
+(NSInteger)getDBVersion;
+(void)setLastDBVersion:(NSInteger)version;
+(NSInteger)getLastDBVersion;


+(UInt32)changeIDToOriginal:(NSString *)sessionID;


+(void)setMsfsUrl:(NSString*)url;
+(NSString*)getMsfsUrl;
@end
