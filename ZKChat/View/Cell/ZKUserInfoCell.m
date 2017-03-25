//
//  ZKUserInfoCell.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/24.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKUserInfoCell.h"
#import "ZKConstant.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"

@implementation ZKUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ZK_WEAKSELF(ws);
        _avatar = [UIImageView new];
        [_avatar setContentMode:UIViewContentModeScaleAspectFit];
        [_avatar setClipsToBounds:YES];
        //        [_avatar.layer setBorderWidth:0.3];
        //        [_avatar.layer setBorderColor:RGB(153,153,153).CGColor];
        [_avatar.layer setCornerRadius:4.0];
        [self.contentView addSubview:_avatar];
        
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(ws.contentView);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(10);
            make.centerY.equalTo(ws.contentView).offset(-16);
            make.size.mas_equalTo(CGSizeMake(100, 16));
        }];
        
        _cnameLabel = [UILabel new];
        [_cnameLabel setTextColor:ZKGRAY];
        [self.contentView addSubview:_cnameLabel];
        [_cnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(10);
            make.centerY.equalTo(ws.contentView).offset(16);
            make.size.mas_equalTo(CGSizeMake(100, 16));
        }];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = RGB(244, 245, 246);
    }
    return self;
}
-(void)setCellContent:(NSString *)avater Name:(NSString *)name Cname:(NSString *)cname{
    self.nameLabel.text=name;
    self.cnameLabel.text=cname;
    UIImage* placeholder = [UIImage imageNamed:@"avatar"];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:avater] placeholderImage:placeholder];
}
@end
