//
//  ZKGroupInfoCell.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/6.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseCell.h"
typedef void(^ChangeSwitch)(BOOL on);

@interface ZKGroupInfoCell : ZKBaseCell
@property(strong)UILabel *desc;
@property(strong)UILabel *detail;
@property(strong)UISwitch *switchIcon;

@property(nonatomic,copy)ChangeSwitch changeSwitch;

-(void)showSwitch;
-(void)opSwitch:(BOOL)status;
-(void)showDesc:(NSString *)desc;
-(void)showDetail:(NSString *)detail;
@end
