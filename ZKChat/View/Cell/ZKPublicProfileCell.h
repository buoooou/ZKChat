//
//  ZKPublicProfileCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/5.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"

@interface ZKPublicProfileCell : ZKBaseCell

@property (nonatomic,strong)UILabel* descLabel;
@property (nonatomic,strong)UILabel* detailLabel;

- (void)setDesc:(NSString *)desc detail:(NSString *)detail;

+(CGFloat)cellHeightForDetailString:(NSString *)string;
@end
