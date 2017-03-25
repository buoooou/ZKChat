//
//  RecordingView.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/4.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, DDRecordingState)
{
    DDShowVolumnState,
    DDShowCancelSendState,
    DDShowRecordTimeTooShort
};
@interface RecordingView : UIView
@property (nonatomic,assign)DDRecordingState recordingState;

- (instancetype)initWithState:(DDRecordingState)state;
- (void)setVolume:(float)volume;
@end
