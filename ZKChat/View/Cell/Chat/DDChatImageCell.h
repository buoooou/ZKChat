//
//  DDChatImageCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/5.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "DDChatBaseCell.h"
#import "MWPhotoBrowser.h"

typedef void(^DDPreview)();
typedef void(^DDTapPreview)();
@interface DDChatImageCell : DDChatBaseCell<DDChatCellProtocol,MWPhotoBrowserDelegate>
@property(nonatomic,strong)UIImageView *msgImgView;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)DDPreview preview;
-(void)showPreview:(NSMutableArray*)photos index:(NSInteger)index;
- (void)sendImageAgain:(ZKMessageEntity*)message;

@end
