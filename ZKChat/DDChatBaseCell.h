//
//  DDChatBaseCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"
#import "DDChatCellProtocol.h"
#import "ZKMessageEntity.h"
#import "MenuImageView.h"
#import "ZKSessionEntity.h"
#import "ZKBubbleModule.h"
#import <TTTAttributedLabel.h>

extern CGFloat const dd_avatarEdge;                 //头像到边缘的距离
extern CGFloat const dd_avatarBubbleGap;             //头像和气泡之间的距离
extern CGFloat const dd_bubbleUpDown;                //气泡到上下边缘的距离

typedef void(^DDSendAgain)();
typedef void(^DDTapInBubble)();
typedef NS_ENUM(NSUInteger, DDBubbleLocationType)
{
    DDBubbleLeft,
    DDBubbleRight
};

@interface DDChatBaseCell : ZKBaseCell<MenuImageViewDelegate,UIAlertViewDelegate,DDChatCellProtocol>
@property (nonatomic,assign)DDBubbleLocationType location;
@property (nonatomic,retain)MenuImageView* bubbleImageView;
@property (nonatomic,retain)UIImageView* userAvatar;
@property (strong) UILabel *userName;
@property (nonatomic,retain)UIActivityIndicatorView* activityView;
@property (nonatomic,retain)UIImageView* sendFailuredImageView;
@property (nonatomic,copy)DDSendAgain sendAgain;
@property (nonatomic,copy)DDTapInBubble tapInBubble;
@property (nonatomic,copy)ZKBubbleConfig* leftConfig;
@property (nonatomic,copy)ZKBubbleConfig* rightConfig;
@property (nonatomic,retain)TTTAttributedLabel* contentLabel;
@property (strong)ZKSessionEntity *session;
- (void)setContent:(ZKMessageEntity*)content;
- (void)showSendFailure;
- (void)showSendSuccess;
- (void)showSending;
@end
