//
//  ZKRecentUserCell.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKRecentUserCell.h"
#import <Masonry/Masonry.h>
#import "ZKConstant.h"
#import "NSDate+DDAddition.h"
#import "UIImageView+WebCache.h"
#import "UIView+Addition.h"

@implementation ZKRecentUserCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarImageView = [UIImageView new];
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_avatarImageView setClipsToBounds:YES];
        [_avatarImageView.layer setCornerRadius:4.0];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
        }];     
        
        _unreadMessageCountLabel = [UILabel new];
        [_unreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
        [_unreadMessageCountLabel setClipsToBounds:YES];
        [_unreadMessageCountLabel.layer setCornerRadius:5];
        [_unreadMessageCountLabel setTextColor:[UIColor whiteColor]];
        [_unreadMessageCountLabel setFont:systemFont(12)];
        [_unreadMessageCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_unreadMessageCountLabel];
        [_unreadMessageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.top.mas_equalTo(4);
            make.right.equalTo(_avatarImageView.mas_right).offset(7);
        }];
        
        _shiledUnreadMessageCountLabel = [UILabel new];
        [_shiledUnreadMessageCountLabel setBackgroundColor:RGB(242, 49, 54)];
        [_shiledUnreadMessageCountLabel setClipsToBounds:YES];
        [_shiledUnreadMessageCountLabel.layer setCornerRadius:5];
        [_shiledUnreadMessageCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_shiledUnreadMessageCountLabel];
        [_shiledUnreadMessageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.top.mas_equalTo(6);
            make.right.equalTo(_avatarImageView.mas_right).offset(4);
        }];
        [_shiledUnreadMessageCountLabel setHidden:YES];
        
        _nameLabel = [UILabel new];
        [_nameLabel setFont:systemFont(17)];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-70);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(17);
        }];
        
        _dateLabel = [UILabel new];
        [_dateLabel setFont:systemFont(12)];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel setTextColor:RGB(170, 170, 170)];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(60);
        }];
        
        _shiledImageView = [UIImageView new];
        UIImage* shieldImg = [UIImage imageNamed:@"shielded"];
        [_shiledImageView setImage:shieldImg];
        [self.contentView addSubview:_shiledImageView];
        [_shiledImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.top.mas_equalTo(_dateLabel.mas_bottom).offset(15);
        }];
        
        _lastmessageLabel = [UILabel new];
        [_lastmessageLabel setFont:systemFont(14)];
        [_lastmessageLabel setTextColor:ZKGRAY];
        [self.contentView addSubview:_lastmessageLabel];
        [_lastmessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-70);
            make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(16);
        }];
        
//        UILabel *bottomLine = [UILabel new];
//        [bottomLine setBackgroundColor:ZKCELLGRAY];
//        [self.contentView addSubview:bottomLine];
//        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0.5);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_lastmessageLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_lastmessageLabel setTextColor:RGB(135, 135, 135)];
        [_dateLabel setTextColor:RGB(135, 135, 135)];
    }
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated               // animate between regular and highlighted state
{
    if (highlighted && self.selected)
    {
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_lastmessageLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_lastmessageLabel setTextColor:RGB(135, 135, 135)];
        [_dateLabel setTextColor:RGB(135, 135, 135)];
    }
}
#pragma mark - public
- (void)setName:(NSString*)name
{
    if (!name)
    {
        [_nameLabel setText:@""];
    }
    else
    {
        [_nameLabel setText:name];
    }
}

- (void)setTimeStamp:(NSUInteger)timeStamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* dateString = [date transformToFuzzyDate];
    [_dateLabel setText:dateString];
}

- (void)setLastMessage:(NSString*)message
{
    if (!message)
    {
        [_lastmessageLabel setText:@"."];
    }
    else
    {
        [_lastmessageLabel setText:message];
    }
}

- (void)setAvatar:(NSString*)avatar
{
    
//    [[_avatarImageView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [(UIView*)obj removeFromSuperview];
//    }];
    
    NSURL* avatarURL = [NSURL URLWithString:avatar];
    UIImage* placeholder = [UIImage imageNamed:@"avatar"];
    [_avatarImageView sd_setImageWithURL:avatarURL placeholderImage:placeholder];
}

- (void)setShiledUnreadMessage
{
    [self.unreadMessageCountLabel setHidden:YES];
    [self.shiledUnreadMessageCountLabel setHidden:NO];
}
- (void)setUnreadMessageCount:(NSUInteger)messageCount
{
    if (messageCount == 0)
    {
        [self.unreadMessageCountLabel setHidden:YES];
    }
    else if (messageCount < 10)
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = [NSString stringWithFormat:@"%li",messageCount];
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:16];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
    else if (messageCount < 99)
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = [NSString stringWithFormat:@"%li",messageCount];
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:25];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
    else
    {
        [self.unreadMessageCountLabel setHidden:NO];
        CGPoint center = self.unreadMessageCountLabel.center;
        NSString* title = @"99+";
        [self.unreadMessageCountLabel setText:title];
        [self.unreadMessageCountLabel setWidth:34];
        [self.unreadMessageCountLabel setCenter:center];
        [self.unreadMessageCountLabel.layer setCornerRadius:8];
    }
}
@end
