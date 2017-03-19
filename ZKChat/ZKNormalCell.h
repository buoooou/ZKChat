//
//  ZKNormalCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/24.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"
typedef void(^ChangeSwitch)(BOOL on);

@interface ZKNormalCell : ZKBaseCell
@property(nonatomic,strong)UILabel *desc;
@property(nonatomic,strong)UILabel *detail;
@property(nonatomic,strong)UIView *topBorder;
@property(nonatomic,strong)UIView *bottomBorder;
@property(nonatomic,strong)UISwitch *switchIcon;

@property(nonatomic,copy)ChangeSwitch changeSwitch;

-(void)showSwitch;
-(void)opSwitch:(BOOL)status;
-(void)showTopBorder;
-(void)showBottomBorder;
- (void)setDetailMessage:(NSString *)detail;
@end
