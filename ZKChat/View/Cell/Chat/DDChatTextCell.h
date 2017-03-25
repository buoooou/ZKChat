//
//  DDChatTextCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDChatBaseCell.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@interface DDChatTextCell : DDChatBaseCell<DDChatCellProtocol,TTTAttributedLabelDelegate>
-(void)sendTextAgain:(ZKMessageEntity *)message;
@end
