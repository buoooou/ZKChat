//
//  ZKPublicProfileViewControll.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseTableViewController.h"

@class ZKUserEntity;
@interface ZKPublicProfileViewController : ZKBaseTableViewController
@property(nonatomic,strong)ZKUserEntity *user;

@property(nonatomic,strong)UIButton *chatBtn;
@end
