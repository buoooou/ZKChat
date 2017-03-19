//
//  ZKContactCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"

@interface ZKContactCell : ZKBaseCell

@property(strong)UIImageView *avatar;
@property(strong)UILabel *nameLabel;
-(void)setCellContent:(NSString *)avater Name:(NSString *)name;

@end
