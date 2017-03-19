//
//  ZKGroupInfoCell.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/6.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKGroupInfoCell.h"
#import <Masonry.h>
#import "ZKConstant.h"
@implementation ZKGroupInfoCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _desc = [UILabel new];
        [self.contentView addSubview:_desc];
        [_desc setTextColor:RGB(164, 165, 169)];
        [_desc setFont:systemFont(15)];
        [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(15);
        }];
        
        _detail = [UILabel new];
        [self.contentView addSubview:_detail];
        [_detail setFont:systemFont(15)];
        [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_desc.mas_right).offset(50);
            make.height.mas_equalTo(15);
        }];
        [_detail setTextAlignment:NSTextAlignmentRight];
        
        _switchIcon = [UISwitch new];
        [_switchIcon setOnTintColor:ZKBLUE];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = RGB(244, 245, 246);
    }
    return self;
}

-(void)showSwitch
{
    [self.contentView addSubview:_switchIcon];
    
    [_switchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(30);
    }];
    
    [_switchIcon addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
}

-(void)showDesc:(NSString *)desc
{
    [_desc setText:desc];
}

-(void)showDetail:(NSString *)detail
{
    [_detail setText:detail];
}

- (void)opSwitch:(BOOL)status
{
    [_switchIcon setOn:status];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)changeSwitch:(UISwitch*)sender
{
    if (self.changeSwitch)
    {
        self.changeSwitch(sender.on);
    }
}

@end
