//
//  ZKBubbleModule.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>

struct ZKBubbleContentInset {
    float top;
    float left;
    float bottom;
    float right;
};
typedef struct ZKBubbleContentInset ZKBubbleContentInset;

struct ZKBubbleVoiceInset {
    float top;
    float left;
    float bottom;
    float right;
};
typedef struct ZKBubbleVoiceInset ZKBubbleVoiceInset;

struct ZKBubbleStretchy {
    float left;
    float top;
};
typedef struct ZKBubbleStretchy ZKBubbleStretchy;



@class ZKBubbleConfig;
@interface ZKBubbleModule : NSObject

+ (instancetype)shareInstance;

- (ZKBubbleConfig*)getBubbleConfigLeft:(BOOL)left;

- (void)selectBubbleTheme:(NSString*)bubbleType left:(BOOL)left;

@end

@interface ZKBubbleConfig : NSObject

@property(nonatomic,assign)ZKBubbleContentInset inset;
@property(nonatomic,assign)ZKBubbleVoiceInset voiceInset;
@property(nonatomic,assign)ZKBubbleStretchy stretchy;
@property(nonatomic,assign)ZKBubbleStretchy imgStretchy;
@property(nonatomic,retain)UIColor* textColor;
@property(nonatomic,retain)UIColor* linkColor;
@property(nonatomic,retain)NSString* textBgImage;
@property(nonatomic,retain)NSString* picBgImage;

- (instancetype)initWithConfig:(NSString*)string left:(BOOL)left;

@end
