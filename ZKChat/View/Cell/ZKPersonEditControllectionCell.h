//
//  ZKPersonEditControllerCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/6.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"

@interface ZKPersonEditControllectionCell : UICollectionViewCell
@property(strong)UIImageView *personIcon;
@property(strong)UIButton *delImg;
@property(strong)UILabel *name;
@property(strong) UIButton *button;
-(void)setContent:(NSString *)name AvatarImage:(NSString *)urlString;
@end
