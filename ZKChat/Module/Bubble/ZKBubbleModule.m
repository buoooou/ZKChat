//
//  ZKBubbleModule.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBubbleModule.h"
#import "ZKUtil.h"
#import "ZKConstant.h"

@implementation ZKBubbleModule
{
    ZKBubbleConfig* _left_config;
    ZKBubbleConfig* _right_config;
}
+ (instancetype)shareInstance
{
    static ZKBubbleModule* g_bubbleModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_bubbleModule = [[ZKBubbleModule alloc] init];
    });
    return g_bubbleModule;
}

- (instancetype)init
{
    //
    self = [super init];
    if (self)
    {
        NSString* leftBubbleType = [ZKUtil getBubbleTypeLeft:YES];
        NSString* rightBubbleType = [ZKUtil getBubbleTypeLeft:NO];
        NSString* leftBubblePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/config.json", leftBubbleType];
        NSString* rightBubblePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/config.json", rightBubbleType];
        NSString* leftPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:leftBubblePath];
        NSString* rightPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:rightBubblePath];
        
        _left_config = [[ZKBubbleConfig alloc] initWithConfig:leftPath left:YES];
        _right_config = [[ZKBubbleConfig alloc] initWithConfig:rightPath left:NO];
        
    }
    return self;
    
}

- (ZKBubbleConfig*)getBubbleConfigLeft:(BOOL)left
{
    if(left){
        return _left_config;
    }
    return _right_config;
}

- (void)selectBubbleTheme:(NSString *)bubbleType left:(BOOL)left
{
    [ZKUtil setBubbleTypeLeft:bubbleType left:left];
    NSString* path = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/config.json", bubbleType];
    NSString* realPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    if(left){
        _left_config = [[ZKBubbleConfig alloc] initWithConfig:realPath left:(BOOL)left];
    }else{
        _right_config = [[ZKBubbleConfig alloc] initWithConfig:realPath left:(BOOL)left];
    }
}

@end

@implementation ZKBubbleConfig

- (instancetype)initWithConfig:(NSString*)string left:(BOOL)left
{
    self = [super init];
    if (self)
    {
        NSString* textBgImagePath;
        NSString* picBgImagePath;
        
        NSData* data = [NSData dataWithContentsOfFile:string];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        ZKBubbleContentInset insetTemp;
        insetTemp.top = [dic[@"contentInset"][@"top"] floatValue];
        insetTemp.bottom = [dic[@"contentInset"][@"bottom"] floatValue];
        if(left){
            insetTemp.left = [dic[@"contentInset"][@"left"] floatValue];
            insetTemp.right = [dic[@"contentInset"][@"right"] floatValue];
        }else{
            insetTemp.left = [dic[@"contentInset"][@"right"] floatValue];
            insetTemp.right = [dic[@"contentInset"][@"left"] floatValue];
        }
        self.inset = insetTemp;
        ZKBubbleVoiceInset voiceInsetTemp;
        voiceInsetTemp.top = [dic[@"voiceInset"][@"top"] floatValue];
        voiceInsetTemp.bottom = [dic[@"voiceInset"][@"bottom"] floatValue];
        if(left){
            voiceInsetTemp.left = [dic[@"voiceInset"][@"left"] floatValue];
            voiceInsetTemp.right = [dic[@"voiceInset"][@"right"] floatValue];
        }else{
            voiceInsetTemp.left = [dic[@"voiceInset"][@"right"] floatValue];
            voiceInsetTemp.right = [dic[@"voiceInset"][@"left"] floatValue];
        }
        self.voiceInset = voiceInsetTemp;
        ZKBubbleStretchy stretchyTemp;
        stretchyTemp.left = [dic[@"stretchy"][@"left"] floatValue];
        stretchyTemp.top = [dic[@"stretchy"][@"top"] floatValue];
        self.stretchy = stretchyTemp;
        ZKBubbleStretchy imgStretchyTemp;
        imgStretchyTemp.left = [dic[@"imgStretchy"][@"left"] floatValue];
        imgStretchyTemp.top = [dic[@"imgStretchy"][@"top"] floatValue];
        self.imgStretchy = imgStretchyTemp;
        NSArray *textColorTemp = [dic[@"textColor"] componentsSeparatedByString:@","];
        self.textColor = RGB([textColorTemp[0] floatValue], [textColorTemp[1] floatValue], [textColorTemp[2] floatValue]);
        NSArray *linkColorTemp = [dic[@"linkColor"] componentsSeparatedByString:@","];
        self.linkColor = RGB([linkColorTemp[0] floatValue], [linkColorTemp[1] floatValue], [linkColorTemp[2] floatValue]);
        
        NSString* bubbleType = [ZKUtil getBubbleTypeLeft:left];
        if(left){
            textBgImagePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/textLeftBubble", bubbleType];
            picBgImagePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/picLeftBubble", bubbleType];
        }else{
            textBgImagePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/textBubble", bubbleType];
            picBgImagePath = [[NSString alloc]initWithFormat:@"bubble.bundle/%@/picBubble", bubbleType];
        }

        self.textBgImage = textBgImagePath;

        self.picBgImage = picBgImagePath;
    }
    return self;
}

@end
