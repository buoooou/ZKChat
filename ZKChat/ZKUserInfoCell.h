//
//  ZKUserInfoCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/24.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"

@interface ZKUserInfoCell : ZKBaseCell
@property(strong)UIImageView *avatar;
@property(strong)UILabel *nameLabel;
@property(strong)UILabel *cnameLabel;
-(void)setCellContent:(NSString *)avater Name:(NSString *)name Cname:(NSString *)cname;
@end
