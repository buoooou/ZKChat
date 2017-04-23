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
#import "ZKConstant.h"

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

#pragma db
+(void)setDBVersion:(NSInteger)version
{
    [[NSUserDefaults standardUserDefaults] setInteger:version forKey:@"dbVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)getDBVersion
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"dbVersion"];
}
+(void)setLastDBVersion:(NSInteger)version
{
    [[NSUserDefaults standardUserDefaults] setInteger:version forKey:@"lastDbVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)getLastDBVersion
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"lastDbVersion"];
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

+(CGSize)sizeTrans:(CGSize)size{
    float width;
    float height;
    float imgWidth = size.width;
    float imgHeight = size.height;
    float radio = size.width/size.height;
    if(radio>=1){
        width = imgWidth > MAX_CHAT_TEXT_WIDTH ? MAX_CHAT_TEXT_WIDTH : imgWidth;
        height = imgWidth > MAX_CHAT_TEXT_WIDTH ? (imgHeight * MAX_CHAT_TEXT_WIDTH / imgWidth):imgHeight;
    }else{
        height = imgHeight > MAX_CHAT_TEXT_WIDTH ? MAX_CHAT_TEXT_WIDTH : imgHeight;
        width = imgHeight > MAX_CHAT_TEXT_WIDTH ? (imgWidth * MAX_CHAT_TEXT_WIDTH / imgHeight):imgWidth;
    }
    return CGSizeMake(width, height);
}
#pragma mark - OriginalID & sessionID

+(UInt32)changeIDToOriginal:(NSString *)sessionID
{
    NSArray *array = [sessionID componentsSeparatedByString:@"_"];
    if (array[1]) {
        return [array[1] unsignedIntValue];
    }
    return 0;
}
@end
