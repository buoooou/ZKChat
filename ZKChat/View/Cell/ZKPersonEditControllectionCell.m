//
//  ZKPersonEditControllerCell.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/6.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKPersonEditControllectionCell.h"
#import <Masonry.h>
#import "ZKConstant.h"
#import "UIImageView+WebCache.h"

@implementation ZKPersonEditControllectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.personIcon = [UIImageView new];
        [self.contentView addSubview:self.personIcon];
        [self.personIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7.5);
            make.left.mas_equalTo(7.5);
            make.size.mas_equalTo(CGSizeMake(57,57));
        }];
        [self.personIcon setClipsToBounds:YES];
        [self.personIcon.layer setCornerRadius:4];
        [self.personIcon.layer setBorderColor:RGB(229, 229, 229).CGColor];
        [self.personIcon.layer setBorderWidth:0.5];
        [self.personIcon setContentMode:UIViewContentModeScaleAspectFill];
        
        self.name = [UILabel new];
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.personIcon.mas_bottom).offset(8);
            make.height.mas_equalTo(13);
            make.left.mas_equalTo(8.5);
            make.centerX.equalTo(self.personIcon);
        }];
        [self.name setTextAlignment:NSTextAlignmentCenter];
        [self.name setFont:[UIFont systemFontOfSize:13.0]];
        [self.name setTextColor:RGB(102, 102, 102)];
        
        self.delImg = [UIButton new];
        [self.delImg setImage:[UIImage imageNamed:@"delImage"] forState:UIControlStateNormal];
        [self.delImg setHidden:YES];
        [self.contentView addSubview:self.delImg];
        [self.delImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(23.5, 23.5));
        }];
        
        
    }
    return self;
}
-(void)setContent:(NSString *)name AvatarImage:(NSString *)urlString
{
    [self.name setText:name];
    if ([urlString isEqualToString:@"add_user_100x100.jpg"]) {
        self.tag=10000;
        self.personIcon.image = [UIImage imageNamed:@"tt_group_manager_add_user"];
    }else if([urlString isEqualToString:@"delete_user_100x100.jpg"])
    {
        self.tag=100001;
        self.personIcon.image = [UIImage imageNamed:@"tt_group_manager_delete_user"];
    }else
    {
        [self.personIcon sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }
    
}

@end
