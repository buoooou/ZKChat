//
//  MenuImageView.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuImageView;
typedef NS_ENUM(NSUInteger, DDImageShowMenu)
{
    DDShowEarphonePlay                      = 1,        //听筒播放
    DDShowSpeakerPlay                       = 1 << 1,   //扬声器播放
    DDShowSendAgain                         = 1 << 2,   //重发
    DDShowCopy                              = 1 << 3,   //复制
    DDShowPreview                           = 1 << 4    //图片预览
};

@protocol MenuImageViewDelegate <NSObject>

- (void)clickTheCopy:(MenuImageView*)imageView;
- (void)clickTheEarphonePlay:(MenuImageView*)imageView;
- (void)clickTheSpeakerPlay:(MenuImageView*)imageView;
- (void)clickTheSendAgain:(MenuImageView*)imageView;
- (void)clickThePreview:(MenuImageView*)imageView;

- (void)tapTheImageView:(MenuImageView*)imageView;
@end
@interface MenuImageView : UIImageView
@property (nonatomic,assign)id<MenuImageViewDelegate> delegate;
@property (nonatomic,assign)DDImageShowMenu showMenu;

- (void)showTheMenu;
@end
