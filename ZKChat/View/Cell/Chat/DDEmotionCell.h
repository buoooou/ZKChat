//
//  DDEmotionCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/9.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDChatImageCell.h"

@interface DDEmotionCell : DDChatImageCell<DDChatCellProtocol>
-(void)sendTextAgain:(ZKMessageEntity *)msg;

@end
