//
//  ZKRecentUserCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"
#import "ZKSessionEntity.h"

@interface ZKRecentUserCell : ZKBaseCell

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView* shiledImageView;
@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong) UILabel* dateLabel;
@property (nonatomic,strong) UILabel* lastmessageLabel;
@property (nonatomic,strong) UILabel* unreadMessageCountLabel;
@property (nonatomic,strong) UILabel* shiledUnreadMessageCountLabel;
@property (assign)NSInteger time_sort;
- (void)setName:(NSString*)name;
- (void)setTimeStamp:(NSUInteger)timeStamp;
- (void)setLastMessage:(NSString*)message;
- (void)setAvatar:(NSString*)avatar;
- (void)setUnreadMessageCount:(NSUInteger)messageCount;
-(void)setShowSession:(ZKSessionEntity *)session;
@end
