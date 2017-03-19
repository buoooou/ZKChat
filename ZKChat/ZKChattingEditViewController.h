//
//  ZKChattingEditViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/6.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"
#import "ZKSessionEntity.h"
#import "ZKGroupEntity.h"

@interface ZKChattingEditViewController : ZKBaseViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(assign)BOOL isGroup;
@property(strong)NSString *groupName;
@property(nonatomic,strong)NSMutableArray *items;
@property(strong)ZKSessionEntity *session;
@property(strong)ZKGroupEntity *group;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
-(void)refreshUsers:(NSMutableArray *)array;

@end
