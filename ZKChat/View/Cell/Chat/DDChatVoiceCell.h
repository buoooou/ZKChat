//
//  DDChatVoiceCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDChatBaseCell.h"
typedef void(^DDEarphonePlay)();
typedef void(^DDSpearerPlay)();

@interface DDChatVoiceCell : DDChatBaseCell<DDChatCellProtocol>
{
    UIImageView* _voiceImageView;
    UILabel* _timeLabel;
    UILabel* _playedLabel;
}
@property (nonatomic,copy)DDEarphonePlay earphonePlay;
@property (nonatomic,copy)DDSpearerPlay speakerPlay;

- (void)showVoicePlayed;
- (void)stopVoicePlayAnimation;
-(void)sendVoiceAgain:(ZKMessageEntity *)message;
@end
