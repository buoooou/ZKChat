//
//  EmotionsModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/3.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionsModule : NSObject
@property (nonatomic,readonly)NSMutableArray* emotions;
@property (nonatomic,readonly)NSDictionary* emotionUnicodeDic;
@property (nonatomic,readonly)NSDictionary* unicodeEmotionDic;
@property (nonatomic,readonly)NSDictionary* emotionLength;
+ (instancetype)shareInstance;
@end
