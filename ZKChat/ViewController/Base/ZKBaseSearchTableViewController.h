//
//  ZKBaseSearchTableViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/16.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseTableViewController.h"

@interface ZKBaseSearchTableViewController : ZKBaseTableViewController

//
//搜索框绑定了控制器
@property(nonatomic) UISearchController *searchController;
//
//搜索结果数据
//
@property(nonatomic,strong)NSMutableArray *filteredDataSource;

//搜索结果控制器,init初始化加载
@property(nonatomic,strong)ZKBaseTableViewController *searchResultController;


@end
