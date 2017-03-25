//
//  ZKAlbumCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"

@interface ZKAlbumCell : ZKBaseCell

@property(strong)UIImageView *avatar;
@property(strong)UILabel *nameLabel;
-(void)setCellContent:(NSString *)avater Name:(NSString *)name;

@end
