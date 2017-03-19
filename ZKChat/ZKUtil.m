//
//  ZKUtil.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKUtil.h"
#import "ZKUserEntity.h"
#import "ZKGroupEntity.h"
typedef NS_ENUM(SInt32, SessionType) {
    SessionTypeSessionTypeSingle = 1,
    SessionTypeSessionTypeGroup = 2,
};
@implementation ZKUtil
+(NSString *)changeOriginalToLocalID:(UInt32)orignalID SessionType:(int)sessionType
{
    if(sessionType == SessionTypeSessionTypeSingle)
    {
        return [ZKUserEntity pbUserIdToLocalID:orignalID];
    }
    return [ZKGroupEntity pbGroupIdToLocalID:orignalID];
}
+(NSDate *)getLastPhotoTime
{
    NSDate *lastDate = [[NSDate alloc] initWithTimeInterval:-90 sinceDate:[NSDate date]];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"preShowImageTime"];
    if(date){
        return date;
    }else{
        return lastDate;
    }
}
+(void)setLastPhotoTime:(NSDate *)date
{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"preShowImageTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)setDBVersion:(NSInteger)version
{
    [[NSUserDefaults standardUserDefaults] setInteger:version forKey:@"dbVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 气泡功能
+(NSString *)getBubbleTypeLeft:(BOOL)left
{
    NSString *bubbleType;
    if(left){
        bubbleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLeftCustomerBubble"];
        if(!bubbleType){
            bubbleType = @"default_white";
        }
    }else{
        bubbleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userRightCustomerBubble"];
        if(!bubbleType){
            bubbleType = @"default_blue";
        }
    }
    return bubbleType;
}
+(void)setBubbleTypeLeft:(NSString *)bubbleType left:(BOOL)left
{
    if(left){
        [[NSUserDefaults standardUserDefaults] setObject:bubbleType forKey:@"userLeftCustomerBubble"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:bubbleType forKey:@"userRightCustomerBubble"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end