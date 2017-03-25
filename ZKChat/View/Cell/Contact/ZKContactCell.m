//
//  ZKContactCell.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKContactCell.h"
#import <Masonry/Masonry.h>
#import "ZKConstant.h"
#import "UIImageView+WebCache.h"

@implementation ZKContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.avatar = [[UIImageView alloc] init];
        [self.contentView addSubview:self.avatar];
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(10);
        }];
        [self.avatar setContentMode:UIViewContentModeScaleAspectFill];
        [self.avatar setClipsToBounds:YES];
        [self.avatar.layer setCornerRadius:2.0];
        
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.right.mas_equalTo(10);
            make.centerY.equalTo(self.contentView);
        }];
        [self.nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = RGB(244, 245, 246);
    }
    return self;
}
-(void)setCellContent:(NSString *)avatar Name:(NSString *)name
{
    self.nameLabel.text=name;
    UIImage* placeholder = [UIImage imageNamed:@"avatar"];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:placeholder];
}


@end
